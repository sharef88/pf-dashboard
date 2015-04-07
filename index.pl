#!/usr/bin/perl 
use CGI qw/standard -no_xhtml/;
use Data::Dumper;
use lib qw?. ./library ?;
use strict;
use warnings;
use util;
my $q = CGI->new();

# set dtd to something html5 savvy
$q->default_dtd('html');

#print $q->header();
print $q->header(
    # date in the past
    -expires       => 'Sat, 26 Jul 1997 05:00:00 GMT',
    # HTTP/1.0
    -Pragma        => 'no-cache',
    # HTTP/1.1 + IE-specific (pre|post)-check
    -Cache_Control => join(', ', qw(
        private
        no-cache
        no-store
        must-revalidate
        max-age=0
        pre-check=0
        post-check=0
    )),
);

    print $q->start_html(
        -title => 'TO Dashboard',
        -style => [
            {
                'src' =>'css/jquery-ui.custom.min.css'
            },
            { 'src' => 'css/index.css' }
        ],
        -script => [
            {
                -type => "text/javascript",
                -src =>"https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"
            },
            {
                -type => "text/javascript",
                -src =>"https://ajax.googleapis.com/ajax/libs/jqueryui/1.9.1/jquery-ui.min.js"
            },
            {
                -type => 'text/javascript',
                -src  => 'js/crypto.js'
            },
            {
                -type => "text/javascript",
                -src  => "js/index.js"
            },
                                                                    
        ]
    );

   print $q->div(
      { id => 'banner' },
      $q->img(
         { src => 'image/banner-bg.png', width => '100%', alt => 'banner' }
      ),
      $q->img( { src => 'image/logo_140x40px.png', alt => 'logo' } ),
      $q->div({id=>'logout', class=>'ui-widget-header ui-corner-all'},
         $q->span(''),
         $q->a({href=>'#'},"Logout")
      )
      
   );

    print $q->start_div( { id => 'over_tabs' } ),
      $q->ul(
        { id => 'over_menu' },
        $q->li(
            { class => '.over_menu' },
            $q->span( { class=> 'over_tab_refresh' },'' ),
            $q->a( { href => 'login.pl', 'data-url'=>'login.pl'}, 'Account' ) 
        ),
        $q->li(
            { class => '.over_menu' },
            $q->span( { class=> 'over_tab_refresh' },''),
            $q->a( { href => 'initative.pl', 'data-url'=>'initative.pl'}, 'Initative Tracker' )
        ),
        $q->li(
            { class => '.over_menu' },
            $q->span( { class=> 'over_tab_refresh' },'' ),
            $q->a( { href => 'class.pl', 'data-url'=>'class.pl' }, 'Class Search' )
        )
      ),
      $q->end_div();
    print $q->div({id=>'RightPanel',class=>'ui-widget-header ui-corner-left'},
        $q->div({class=>'panel_handle ui-widget-header ui-corner-left'},'<p>stuff</p>'),
        $q->div({class=>'panel_content ui-corner-left ui-widget-content'},"OMG, IT'S LOTS OF HIDDEN STUFF")
      ),
      $q->end_html();


