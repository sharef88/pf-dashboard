#!/usr/local/bin/perl
use strict;
use warnings;
use lib qw/library/;
use Class::db;
use Data::Dumper;
use Data::Uniqid qw/uniqid/;
use CGI;
use Try::Tiny;

use Email::Sender::Simple qw(sendmail);
use Email::Simple;
use Email::Simple::Creator;

my $q = CGI->new;

my $stuff = db->new;

#my $email = Email::Simple->create(
#  header => [
#    To      => '"Andy" <gamerzi@gmail.com>',
#    From    => '"Orbanos" <admin@orbanos.org>',
#    Subject => "message from dev.orbanos",
#  ],
#  body => "Greetings from andy's site!\n",
#);

#sendmail($email);

print Dumper(@INC);

#print uniqid;

