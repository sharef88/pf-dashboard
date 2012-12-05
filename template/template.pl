#!/usr/bin/perl
use CGI qw/standard -no_xhtml/;
use Data::Dumper;
use strict;
use warnings;
use dnd_util qw/dice/;
my $q = CGI->new();
$q->default_dtd('html');

print $q->header();

unless ( $q->param('len') ) {

    print $q->start_html(
        -title => 'TO Dashboard',
        -style => [
            {
                'src' =>'jquery-ui-1.9.1.custom/css/orbanos/jquery-ui-1.9.1.custom.min.css'
            },
            { 'src' => 'css/index.css' }
        ],
        -script => [
            {
                -type => "text/javascript",
                -src  => "js/index.js"
            },
        ]
    );
    print $q->div(" ohai, a page that sharef hasn't filled in yet ");



    print $q->end_html();

}

