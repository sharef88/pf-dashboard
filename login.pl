#!/usr/local/bin/perl
use CGI qw/standard -no_xhtml/;
use Data::Dumper;
use Email::Valid;
use lib qw( library /home/sharef/perl5/lib/perl5/i686-linux /home/sharef/perl5/lib/perl5/i686-linux-thread-multi /home/sharef/perl5/lib/perl5 );
use strict;
use warnings;
use util qw/dice/;

use Class::db;

my $db = db->new;

my $q = CGI->new;
$q->default_dtd('html');


my @input;
eval { 
   @input = $q->param('session') ? @{decode_json($q->param('session'))} : @{[404,0,0]}; 
};
if ( $@ ) {
   @input = @{[404]};
}

#my $test =  {};
my %test = map { $_ => $_ } (200,201,202);

if ( exists $test{$input[0]} ) {
   print $q->header;
   print "<script type='text/javascript'>
      \$(this).account();
      </script>";
   exit;
}



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
         $q->input({type=>'text', name=>'username', id=>'login_username', required=>''})
		
      ),
      $q->span({id=>'login_password'},
         $q->label({for=>'login_password'},'Password'),
         $q->input({type=>'password', name=>'password', id=>'login_password', required=>''})
      );


   #register div, hidden
   print $q->div({id=>'register_div', style=>'display:none'},
      $q->span({id=>'register_password'},
         $q->label({for=>'register_password'},'Password (Again)'),
         $q->input({type=>'password', name=>'password2', id=>'register_password', required=>''})
      ),
      $q->span({id=>'register_email'},
         $q->label({for=>'register_email'},'Email'),
         $q->input({type=>'email', name=>'email', id=>'register_email', required=>''})
      ),
      $q->p,
      $q->h4('Auth Code'),
      $q->hr,
      $q->span({id=>'register_gm', title=>'Get this from your GM'},
         $q->label({for=>'register_gm'},'GM Name'),
         $q->input({type=>'text', name=>'gm', id=>'register_gm', required=>''})
      ),
      $q->span({id=>'register_auth', title=>'Get this from your GM'},
         $q->label({for=>'register_auth'},'Auth-Code'),
         $q->input({type=>'text', name=>'auth', id=>'register_auth', required=>''})
      ),
      $q->p,
      $q->p,
      $q->h4('Game Options'),
      $q->hr,
      $q->span({id=>'register_character'},
         $q->label({for=>'register_character'},'Main Character'),
         $q->input({type=>'text', name=>'character', id=>'register_character'})
      ),
      $q->span({id=>'register_system'},
         $q->label('Primary System'),
         $q->div(
            $q->label({for=>'system_gram'},'GRAM'),
            $q->input({type=>'radio', name=>'system', value=>'GRAM', id=>'system_gram'}),
            $q->label({for=>'system_pf'},'Pathfinder'),
            $q->input({type=>'radio', name=>'system', value=>'Pathfinder', id=>'system_pf', checked=>'checked'}),
         )
      ),
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
         $db->user('sessionupdate',$token, $login_time, $user->{'name'}, $user->{'id'});

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
   #headers, for json
   print $q->header('application/json');

   #initilize the output array, for json encoding
   my @output;

   #grab the params
   my $params = $q->Vars;

   #valid unverified keys
   my @key = ('username','gm','auth','character','system');

   #initilize the input
   my $input;


   #validate the email

   if ( Email::Valid->address($params->{email}) ) {
      $input->{email} = $params->{email};
   } else { 
      push @output, '416';
      print encode_json( \@output );
      exit;
   }


   #validate the password values

   if ( $params->{password} eq $params->{password2} ) {
      map { $input->{$_} = $params->{$_} }  ('password','password2');
   } else {
      push @output, '416';
      print encode_json( \@output );
      exit;
   }

   #map the rest of the valid inputs to the input
   map { $input->{$_} = $params->{$_} } @key;
   
   my @reg = $db->register($input);
   if ( @reg ) {
      push @output, '201';
      push @output, @reg;
   } else {
      print @reg;
      push @output, '409';
   }
   print encode_json(\@output);
   


}
