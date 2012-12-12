#!/usr/bin/perl
use CGI qw/standard -no_xhtml/;
use lib qw/library/;
use Data::Dumper;
use strict;
use warnings;
use util qw/dice/;
use Class::db;

my $db = db->new;
my $q = CGI->new;

$q->default_dtd('html');

#24hrs in second format
my $Default_Timeout = 86400;

print $q->header();


#Validate json, can't use JSON::Schema due to perl version mismatch (5.8.8 vs 5.10)
my @input;

#eat the error code from bad json codes
eval { 
   @input = $q->param('session') ? @{decode_json($q->param('session'))} : @{[404,0,0]}; 
};
#regurgitate the error as a 500, then cause a logout, which will clear the session value;
if ( $@ ) {
   @input = @{[500]}; #pointless, but may be useful later
   print "<script type=text/javascript>
      \$(this).logout();
      </script>";
   exit;
}


#session checking
my $user = $db->user('sessioncheck',$input[1],time-$Default_Timeout);


unless ( $q->param('login') ) {
   print $q->Link({ href=> 'css/account.css', rel=>'stylesheet',type=>'text/css' });
    
   print $q->start_div( { id => 'account_tabs' } ),
      $q->ul(
        { id => 'account_menu' },
        $q->li(
            { class => '.account_menu' },
            $q->a( { href => '#account_personal'}, 'Personal Details' ) 
        ),
        $q->li(
            { class => '.account_menu' },
            $q->a( { href => '#account_game'}, 'Game Preferences' )
        ),
      ),
      $q->div({id=>'account_personal'},
         "You are $user->{name}<p>
         Dis is all unformatted, so shaddup"
      ),
      $q->div({id=>'account_game'},
         "This is the 'Game Preferences tab'<p>You prefer $user->{games}"
      ),
      $q->end_div();



    

   print $q->script({type=>'text/javascript', src=>'js/account.js'});

}

