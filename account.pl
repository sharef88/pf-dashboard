#!/usr/bin/perl
use CGI qw/standard -no_xhtml/;
use lib qw/library/;
use Data::Dumper;
use strict;
use warnings;
use util qw/dice/;
use Class::db;
use JSON::Schema;

my $validate = JSON::Schema->new;

my $db = db->new;
my $q = CGI->new;

$q->default_dtd('html');

print $q->header();


my @input = $q->param('session') ? @{decode_json($q->param('session'))} : @{[404,0,0]};
if ( $q->param('session') ) {
   if ( $validate->validate($q->param('session')) ) {
      print 'valid';
   }
}


unless ( $q->param('login') ) {
   print $q->Link({ href=> 'css/account.css', rel=>'stylesheet',type=>'text/css' });
    
   print $q->div(" ohai, a page that sharef hasn't filled in yet ");

   print $q->script({type=>'text/javascript', src=>'js/account.js'});

}

