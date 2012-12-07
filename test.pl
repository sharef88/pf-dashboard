#!/usr/bin/perl
use strict;
use warnings;
use lib qw/library/;
use Class::db;
use Data::Dumper;

my $stuff = db->new;
#print Dumper($stuff);
#print $stuff->cursor;
print Dumper($stuff->user("NPC"));
print Dumper($stuff->class('stats',6));
