#!/usr/bin/perl
use CGI qw/standard -no_xhtml/;
use Data::Dumper;
use lib qw/library/;
use strict;
use warnings;
use util qw/dice/;
my $q = CGI->new();
$q->default_dtd('html');

my @input = $q->param('token') ? @{decode_json($q->param('token'))} : @{[404,0,0]};
print $q->header();

unless ( $q->param('login') || $q->param('register') ) {

    print $q->Link({ src=> 'css/index.css', rel=>'stylesheet',type=>'text/css' });
    
    print $q->div(" ohai, a page that sharef screwed up, oops! ".$input[1]);



	print $q->script({type => "text/javascript",src=> "js/login.js"});

} elsif ($q->param('login')) {




} elsif ($q->param('register')) {

}

