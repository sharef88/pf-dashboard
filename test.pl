#!/usr/local/bin/perl
use strict;
use warnings;
use lib qw/library/;

use Class::db::rules;
use Class::db::user;
use util;
use pfdash::Schema;
use config;

use Data::Dumper;
use CGI;
use MIME::Lite;

my $q = CGI->new;

#my $rules = rules->new;
#my $user = user->new({name=>'sharef'});
my $schema = pfdash::Schema->connect("dbi:mysql:dbname=$config::db", $config::user, $config::pw);
$schema->storage->debug(1);

my $msg = MIME::Lite->new( 
   From => 'admin@orbanos.org', 
   To=> 'gamerzi@gmail.com', 
   Type => 'text/plain', 
   Subject => 'Hello from orbanos!' , 
   Data => 'Greetings from dev.orbanos.org'
); 

#$msg->send;


#my $arch1 = $schema->resultset('ArchList')->find({name=>'Monk'})->abilities;
#print join ", ", $arch1->get_column('name')->func('distinct');
my $user_options = $schema->resultset('User')->find({name=>'sharef'})->options;
print join ", ", $user_options->first->option_value;






