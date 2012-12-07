#!/usr/bin/perl
use strict;
use warnings;
use lib qw/library/;
use Class::db;
use Data::Dumper;

my $stuff = db->new;
#print Dumper($stuff);
#print $stuff->cursor;
my $test = @{$stuff->class('stats',6)}[0];
my @abilities = @{$stuff->class('abilities',6, 5)};
my $stats = @{$stuff->class('stats',6)}[0];

print Dumper($stats);
#my $arch = $abilities[0]->{'arch'};
#print $class,$arch;               

#my @keys = keys *$test;
#print Dumper( $test->{'ability_columns'} );
