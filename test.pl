#!/usr/bin/perl
use strict;
use warnings;
use lib qw/library/;
use Class::db;
use Class;

my $stuff = db->new;
print $stuff;

