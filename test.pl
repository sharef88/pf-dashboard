#!/usr/local/bin/perl
use strict;
use warnings;
use lib qw/library/;

use Class::db::rules;
use Class::db::user;
use util;

use Data::Dumper;
use CGI;
use MIME::Lite;

my $q = CGI->new;

my $rules = rules->new;
my $user = user->new({name=>'sharef'});

my $msg = MIME::Lite->new( 
   From => 'admin@orbanos.org', 
   To=> 'gamerzi@gmail.com', 
   Type => 'text/plain', 
   Subject => 'Hello from orbanos!' , 
   Data => 'Greetings from dev.orbanos.org'
); 

#$msg->send;

print sha256_hex($q->param('password').$user->{'salt'});
print Dumper($user->user('id',2));

#print Dumper(@stuff);
