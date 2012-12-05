#!/usr/bin/perl
package config;
#use library::Class::Class;
#use base qw(Class::Class);
require DBI;
use warnings;
use strict;
use CGI;
my $q = CGI->new;



#where is the stuff?
my $host = "localhost";
my $database = "sharef_dnd";
my $tablename = "character";
my $user = "sharef_dnd";
my $pw = "penguin";

#connect to the stuff's home
our $cursor = DBI->connect("DBi:mysql:$database",$user,$pw, {AutoCommit => 1});

$cursor->{HandleError} = sub { print $q->script("console.log('zomg the error is: $_[0]')"); };

1;
