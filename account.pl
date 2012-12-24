#!/usr/local/bin/perl
use CGI qw/standard -no_xhtml/;
use lib qw/library/;
use Data::Dumper;
use strict;
use warnings;
use util qw/dice/;
use Class::db::user;

my $q = CGI->new;

$q->default_dtd('html');

#24hrs in second format
my $Default_Timeout = 86400;

print $q->header();


#Validate json, can't use JSON::Schema due to perl version mismatch (5.8.8 vs 5.10)
my @input;

#eat the error code from bad json codes
eval { 
   if ( exists $q->Vars->{'session'} ) {
      @input =  @{decode_json($q->param('session'))} 
   } else {
      print "<script type=text/javascript>
         \$(this).logout();
         </script>";
      exit;
   }
};
#regurgitate the error as a 500, then cause a logout, which will clear the session value, thus clearing the bad json;
if ( $@ ) {
   @input = @{[500]}; #pointless, but may be useful later
   print "<script type=text/javascript>
      \$(this).logout();
      </script>";
   exit;
}

#Get the corresponding user to the session id
my $user = user->new({session=>$input[1]});

#if the user comes back as a 404, the session was invalid, force-logout to clear session
if ( $user->{name} eq '404' ) {
   print "<script type=text/javascript>
      \$(this).logout();
      </script>";
   exit;
}

#print a jquery statement to insert the user next to the logout button
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
   ), #end ul#account_menu
   
   #Print the actual pages
   $q->div({id=>'account_personal'},
      "You are $user->{name}<p>
      Dis is all unformatted, so shaddup"
   ), #end div#account_personal
   
   $q->div({id=>'account_game'},
      "This is the 'Game Preferences tab'<p>You prefer $user->{games}"
   ); #end div#account_game

   
   print $q->start_div({id=>'account_token'});

      print "<div id='token_tables'>";
         print "<h3>Owned Tokens</h3>"; 
         print "<div id= 'owned_tokens' class='token_table ui-widget-header ui-corner-bottom'>";
         foreach ( $user->token('owned') ) {
            print qq%
            <span>
               <span class = 'token_flag ui-state-default ui-corner-all'>$_->{flag}</span>
               <span class = 'token_code ui-state-default ui-corner-all'>$_->{code}</span>
               <span class = 'token_target ui-state-default ui-corner-all'>$_->{target_name}</span>
               <span class = 'token_notes ui-state-default ui-corner-all'>$_->{notes}</span>
            </span>
            %;
         }
         print "</div>"; #end owned_tokens

         print "<h3>Assigned Tokens</h3>";
         print "<div id= 'assigned_tokens' class='token_table ui-widget-header ui-corner-bottom'>";
         foreach ( $user->token('assigned') ) {
            print qq%
            <span>
               <span class = 'token_flag ui-state-default ui-corner-all'>$_->{flag}</span>
               <span class = 'token_code ui-state-default ui-corner-all'>$_->{code}</span>
               <span class = 'token_source ui-state-default ui-corner-all'>$_->{source_name}</span>
               <span class = 'token_note ui-state-default ui-corner-all'>$_->{notes}</span>
            </span>
            %;
         }
         print "</div>"; #end assigned_tokens
      print "</div>"; #end token_tables

   
   print $q->end_div(), #end div#account_token
   $q->end_div; #end div#account_tabs



 

print $q->script({type=>'text/javascript', src=>'js/account.js'});


