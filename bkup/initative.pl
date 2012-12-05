#!/usr/bin/perl
use CGI qw/standard/;
use Data::Dumper;
use strict;
use warnings;
use dnd_util qw/dice/;
my $q = CGI->new();

unless($q->param('row')) {

print $q->header(),
$q->start_html(
  -title=>'TO Initative Tracker',
  -author=>'admin@orbanos.org',
  -style=>[
    {'src'=>'dot-luv/jquery-ui-1.8.22.custom.css'},
    {'src'=>'initative.css'}
  ],
  -script=>[
    {
      -type=>"text/javascript",
      -src=>"https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"
    },
    {
      -type=>"text/javascript",
      -src=>"https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.21/jquery-ui.min.js"
    },
    {
      -type=>"text/javascript",
      -src=>"initative.js"
    },
  ]
),
$q->a({href=>'index.html'},"<< back");


print $q->start_form(
  -method=>'GET',
  -id=>'input_init',
  -class=>'init'),
$q->hidden(-id=>'len',-name=>'len'),
$q->table({-id=>'init'},
  $q->Tr($q->th([
    'Name',
    'Init.',
  ]))
),
$q->end_form(),
$q->button(-onclick=>'list_actors()',-value=>'Console out');

print $q->div({-id=>'info'}),
$q->end_html();
} else {

#Row Definition, Called through Ajax
my $i = $q->param('row')+1;
print $q->header(),
$q->Tr({class=>'actor'},
  $q->td([
    $q->textfield(-id=>''),
      #Init calculation and stuff
      $q->div({id=>'sum',class=>'sum_div'},
        $q->button(-id=>'sum',-class=>'sum_field',-readonly=>'true',-style=>'text-align:center;'),
        $q->div({class=>'extra',style=>"display: none"},
          #Table for extra info
          $q->div({class=>'roll_div'},
            $q->textfield(-default=>&dice,-class=>'roll',-placeholder=>'d20 roll'),
            $q->span('>')
          ),
          $q->div({class=>'mod_div'},
            $q->textfield(-default=>0,-class=>'mod',-placeholder=>'modifier'),
            $q->span('<')
          ),
        ),
      ),
    $q->button(-name=>'add',-value=>"+", -class=>'add_actor',),
    $q->button(-name=>'add',-value=>"-", -class=>'remove_actor',-touchend=>"remove_actor(this);")

    ])
  );
}
