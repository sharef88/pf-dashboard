#!/usr/local/bin/perl
use strict;
use warnings;
use lib qw/library/;
use Class::db;
use Data::Dumper;
use Data::Uniqid qw/uniqid/;
use CGI;
use Try::Tiny;
use MIME::Lite;

my $q = CGI->new;

my $db = db->new;

my $msg = MIME::Lite->new( 
   From => 'admin@orbanos.org', 
   To=> 'gamerzi@gmail.com', 
   Type => 'text/plain', 
   Subject => 'Hello from orbanos!' , 
   Data => 'Greetings from dev.orbanos.org'
); 

#$msg->send;
my $user = $db->user('user','sharef');


my @stuff = $db->token($user->{name},'assigned');
print Dumper(@stuff);



#print uniqid;

