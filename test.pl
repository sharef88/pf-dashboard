#!/usr/bin/perl
use strict;
use warnings;
use lib qw/library/;
use Class::db;
use Data::Dumper;

my $stuff = db->new;
print Dumper(db->new);
print Dumper($stuff);
print Dumper($stuff->DBI);

