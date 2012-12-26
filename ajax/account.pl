#!/usr/local/bin/perl
use CGI qw/standard -no_xhtml/;
use lib qw[.. ../library];
use Data::Dumper;
use strict;
use warnings;
use util qw/dice/;
use Class::db::user;

my $q = CGI->new;

$q->default_dtd('html');



#------------------------------------#
#++++++++ Session Validation ++++++++#
#------------------------------------#

my @input;
my $user;

#eat any and all errors from checking the session variable
#If there are errors, die gracefully with a logout
eval { 
   #if there isn't a session var set
   #or the json in the session var is bad
   #this dies
   @input =  @{decode_json($q->Vars->{'session'})} or die; 
   #If the instance comes back empty, die
   $user = user->new({session=>$input[1]}) or die;
};
#if any of the eval fails, force logout
if ( $@ ) {
   print $q->header;
   print "<script type=text/javascript>
      \$(this).logout();
      </script>";
   exit;
}

#print a jquery statement to insert the user next to the logout button
print $q->header;
print <<"END";
<script>
   \$('#logout>span').html('User: $user->{name}');
</script>
END



#--------------------------------------------#
#+++++++++++ Print the actual page ++++++++++#
#--------------------------------------------#


#first the stylesheet
print $q->Link({ href=> 'css/account.css', rel=>'stylesheet',type=>'text/css' });
 

#account page
print $q->start_div( { id => 'account_tabs' } ),
   #Print the tabs
   $q->ul(
     { id => 'account_menu' },
     #option 1: personal stuff
     $q->li(
         { class => 'account_menu' },
         $q->a( { href => '#account_personal'}, 'Personal Details' ) 
     ),
     #option 2: game stuff
     $q->li(
         { class => 'account_menu' },
         $q->a( { href => '#account_game'}, 'Game Preferences' )
     ),
     $q->li(
        { class => 'account_menu' },
        $q->a( { href => '#account_token'}, 'Token Management' )
      ),
   ); #end ul#account_menu
   
   #Print the actual pages
   print $q->div({id=>'account_personal'});
      print "<h3>Welcome $user->{name}</h3>";
      print "<form>";
      #loop over the main options
      foreach ( @{$user->options} ) {
         if ($_->{grouping} eq 'personal') {
            
            #will error if you try to ->{option_value} on a null value
            my $check = @{$user->options($_->{name})}[0];
            my $option = ref($check) ? $check->{value} : '';
            
            #actually print the entry
            my $label = "<label>$_->{name}</label>";
            my $input;

            if ( $_->{name} eq 'Gender' ) {
               #gender special case printing
               my $male = qq%
                  <label for='gender_male'>Male</label>
                  <input type='radio', name='$_->{name}' value='Male' id='gender_male' %;
               my $female = qq%
                  <label for='gender_female'>Female</label>
                  <input type='radio' name='$_->{name}' value='Female' id='gender_female' %;
               if ( $option eq 'Male' ) {
                  $male .= 'checked >';
                  $female .= '>';
               } elsif ( $option eq 'Female' ) {
                  $female .= 'checked >';
                  $male .= '>';
               }
               
               $input = $q->div({id=>'gender'},$male,$female);
            } else {
               $input = qq%<input value="$option" type='text' name='$_->{name}'></input>%;
            }
            print qq%<span>$label $input</span>%;
         }
      }

      print qq%
      <span class='account_control'><input type="submit" value="Save"></span>
      %;
      
      print "</form>";
   print $q->end_div; #end div#account_personal
   
   print $q->start_div({id=>'account_game'});
      my $game = @{@{$user->options('Prefered Game')}[0]}{value};
      print "This is the 'Game Preferences tab'<p>You prefer $game";
      
   print $q->end_div; #end div#account_game

   
   print $q->start_div({id=>'account_token'});

      print "<div id='token_tables'>";
         print "<h3>Owned Tokens</h3>"; 
         print "<div id= 'owned_tokens' class='token_table ui-widget-header ui-corner-bottom'>";
         foreach my $i ( $user->token('owned') ) {
            #start span-list entry
            print "<span>";
               #populate list entry
               foreach ('flag','code','target_name','notes') {
                  print "<span class = 'token_$_ ui-state-default ui-corner-all'>$i->{$_}</span>";
               }
            #end span-list
            print "</span>";
         }
         print "</div>"; #end owned_tokens

         print "<h3>Assigned Tokens</h3>";
         print "<div id= 'assigned_tokens' class='token_table ui-widget-header ui-corner-bottom'>";
         foreach my $i ( $user->token('assigned') ) {
            #start span-list entry
            print "<span>";
               #populate list entry
               foreach ('flag','code','source_name','notes') {
                  print "<span class = 'token_$_ ui-state-default ui-corner-all'>$i->{$_}</span>";
               }
            #end span-list
            print "</span>";
         }
         print "</div>"; #end assigned_tokens
      print "</div>"; #end token_tables

   
   print $q->end_div(), #end div#account_token
$q->end_div; #end div#account_tabs

print $q->script({type=>'text/javascript', src=>'js/account.js'});


