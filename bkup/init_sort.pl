#!/usr/bin/perl
use CGI qw/standard/;
use Data::Dumper;
use warnings;
use strict;
use dnd_util qw/dice/;
my $q = CGI->new();

print $q->header();
my @input = $q->param();
my $length= $q->param('len');
my @results;
for (my $i=1; $i<=$length; $i++) { 
  my @out = $q->param($input[$i]);
  push @results, ([$out[0],$out[1]+$out[2],$out[1],$out[2]]);
}
my @sorted = sort {$b->[1] <=> $a->[1]} @results;

print $q->start_ul({class=>'sorted'});
foreach (@sorted) {
    print $q->li({class=>"ui-state-default ui-corner-all"},
      $q->span([$$_[1],"(",$$_[2],'+',$$_[3],') : ',$$_[0]])
    );
}
print $q->end_ul();
