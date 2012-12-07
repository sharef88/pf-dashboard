#!/usr/bin/perl
use strict;
use warnings;
use lib qw/library/;
use Class::db;
use Data::Dumper;

my $stuff = db->new;



#my @abilities = @{$stuff->class('abilities',11, 5)};
#my $stats = @{$stuff->class('stats',11)}[0];
#my ($class, $arch) = @{$stats}{'base','name'};
#print $class,$arch,Dumper($stats),Dumper($abilities[0]);

my $info = $stuff->user('available tokens','NPC');
print Dumper($info);
