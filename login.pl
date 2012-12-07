#!/usr/bin/perl
use CGI qw/standard -no_xhtml/;
use Data::Dumper;
use lib qw/library/;
use strict;
use warnings;
use util qw/dice/;

use Class::db;

my $db = db->new;

my $q = CGI->new;
$q->default_dtd('html');

my @input = $q->param('token') ? @{decode_json($q->param('token'))} : @{[404,0,0]};

unless ( $q->param('login') || $q->param('register') ) {
   print $q->header;
	
   #declare stylesheet
   print $q->Link({ href=> 'css/login.css', rel=>'stylesheet',type=>'text/css' });
   
   print $q->start_div({id=>'login_tab'});

   #login page
   print $q->start_div({id=>'login_div'}),
      $q->start_form({id=>'login'}),
      $q->input({type=>'hidden',value=>'true',name=>'login'}),
      $q->h3('Login'),
      $q->span({id=>'login_name'},
         $q->label({for=>'login_username'},'Username'),
         $q->input({type=>'text', name=>'username', id=>'login_username'})
		
      ),
      $q->span({id=>'login_password'},
         $q->label({for=>'login_password'},'Password'),
         $q->input({type=>'password', name=>'password', id=>'login_password'})
      );


   #register div, hidden
   print $q->div({id=>'register_div', style=>'display:none'},
      $q->span({id=>'register_password'},
         $q->label({for=>'register_password'},'Password (Again)'),
         $q->input({type=>'password', name=>'password2', id=>'register_password'})
      )
   );

   #login control
   print $q->span({id=>'login_control'},
      $q->submit({name=>'submit',value=>'Login'}),
      $q->a({id=>'forgot_password', href=>'#'},'Forgot Password?'),
      $q->a({id=>'register', href=>'#'},'Register'),
   );

	

	

   print $q->end_form,
   $q->end_div,
   $q->end_div;	
   #divtest, for testing (duh?)
   print $q->div({id=>'test_div'}," ohai, a page that sharef screwed up, oops! "."He isn't done restoring it yet....");

   #script declaration
   print $q->script({type => "text/javascript",src=> "js/login.js"});

} elsif ($q->param('login')) {
   print $q->header('application/json');
   my @output;
	
   #scope the sql statement

   my $user = $db->user('user',$q->param('username'));
   if ( exists $user->{'name'} ) {
      #fetch the infos
		
      if ( sha256_hex($q->param('password').$user->{'salt'}) eq $user->{'password'} ) {
         my $login_time = time;
         #behold, convoluted token generation.  Instead of generating a random number, this effectivly guarntees unique tokens
         my $token =  sha256_hex($user->{'name'}.$user->{'salt'}.$login_time);
         #put the token into the sql db, double verify the spot you're putting it with name and id
         $db->user('tokenupdate',$token, $login_time, $user->{'name'}, $user->{'id'});

         #push the appropriate data into the output for json conversion
         push @output, (202, $token, $login_time);

      } else {
         #wrong password, 401-not authorized
         push @output, 401;
      } 
   } else {
      #no user of that name, 404-not found
      push @output, 404;
   }
	
   #encode the json properly.
   print encode_json(\@output);	




} elsif ($q->param('register')) {

}



$config::cursor->disconnect;
