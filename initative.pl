#!/usr/bin/perl
use CGI qw/standard -no_xhtml/;
use lib qw/library/;
use strict;
use warnings;
use util;

my $q = CGI->new();
$q->default_dtd('html');

print $q->header();

unless ( $q->param('len') ) {
   print $q->Link({ href=> 'css/initative.css', rel=>'stylesheet',type=>'text/css' });
	
      print $q->start_div( { id => 'initative' } ),
      $q->start_div( { id => 'init_tabs' } ),
      $q->ul(
        $q->li(
            { class => '.init_menu', id => 'entry' },
            $q->a( { href => '#entries' }, 'Input' )
        ),
        $q->li(
            { class => '.init_menu', id => 'sorted' },
            $q->a( { href => '#sorted_entry', class => 'results' }, 'Results' )
        )
      ),
      $q->start_div( { id => 'entries' } );

    print $q->start_form(
        -method => 'GET',
        -id     => 'input_init',
        -class  => 'init'
      ),
      $q->hidden( -id => 'len', -name => 'len' ),

      $q->ul( { -id => 'init', class => 'entries sortable' },
        "<li id='null'> </li>" ),

      $q->end_form();

    print $q->end_div(),
      $q->div( { -id => 'sorted_entry' }, '<span>stuff</span>' ),
      $q->end_div(),
      $q->end_div(),
      $q->end_div();
   print $q->script({type=>'text/javascript', src=>'js/initative.js'});

}
else {

    print $q->div( { id => 'init_control' } );

    my @input  = $q->param();
    my $length = $q->param('len');
    my @results;
    for ( my $i = 1 ; $i <= $length ; $i++ ) {
        my @out = $q->param( $input[$i] );
        push @results, ( [ $out[0], $out[1] + $out[2], $out[1], $out[2] ] );
    }
    my @sorted = sort { $b->[1] <=> $a->[1] } @results;

    print $q->start_div( { class => 'sorted' } );
    my $actor = 0;
    foreach (@sorted) {
        if ( $$_[0] eq "" ) {
            $$_[0] = 'Actor_' . $actor;
        }
        print $q->start_div( { class => 'group' } ),
          $q->span(
            { class => "active" },
            $q->div(
                { class => 'position_number' },
                $q->div(
                    {
                        class => 'number ui-state-hover ui-corner-all',
                        title => '(' . $$_[2] . '+' . $$_[3] . ')'
                    },
                    $$_[1]
                ),
            ),
            $q->div(
                { class => 'active_info ui-state-default ui-corner-all' },
                $q->div( { class => 'name' }, $$_[0] )
            )
          ),
          $q->div( { class => 'more_info' },
            'This is where the character sheet and stats go' ),
          $q->end_div();
        $actor = $actor + 1;
    }
    print $q->end_div();
}

