#!/usr/bin/perl
use DBI;
use Data::Dumper;
use CGI qw/:standard/;
use warnings;
use strict;
use dnd_config;
my $q = CGI->new;

#browsers must behave
print $q->header();

#parameter style stuff
my $arch = param('arch');
my $level = param('level');
$level = 20 if ($level>20 || ! $level || $level<1);


#get the stuff
my $stuff = $dnd_config::sql_class;
$stuff->execute($arch,$level);
my $meta_data = $dnd_config::sql_class_meta;
$meta_data->execute($arch);

#store the stuff in an array
my @abilities;
while (my $row = $stuff->fetchrow_hashref()) {
  push (@abilities,$row);
}
my @meta_list;
while (my $row = $meta_data->fetchrow_hashref()) {
  push (@meta_list,$row);
}

my $class=$abilities[0]->{'class'};
$arch=$abilities[0]->{'arch'};

my $what = "$class ";
if ($class ne  $arch) {
$what.="($arch)";
}

print $q->start_html(
  -title=>$what,
  -head=>[
    Link({rel=>"stylesheet",type=>"text/css",href=>"class.css"}),
    ],
  -script=>[
    {
      -type=>"text/javascript",
      -src=>"jquery.js"
    },
    {
      -type=>"text/javascript",
      -src=>"class.js"
    },
  ],
),

$q->a({href=>"get_class.pl"},"<< back");


#start the table, make the headers
print $q->start_table({id=>'level_progression'}),
$q->Tr(th({colspan=>6},"$level Level $what")),
$q->Tr(th(['Level','Bab','Fort','Ref','Will','Abilities']));


#print the stuff by level
foreach our $a (1..$level) {
  print "<tr><td class='level'> $a </td>";
    #deal with the meta-info (bab, saves)

    #base attack bonus
    print "<td class='bab'>";
    print int($a*($meta_list[0]->{'bab'}/100));
    print "</td>";
    #saves
    foreach('fort','ref','will') {
      print "<td class='saves'>";
      print int( ( $a / 2 ) + 2 ) if ($meta_list[0]->{"$_"} eq "good");
      print int( $a / 3 ) if ($meta_list[0]->{"$_"} eq "poor");
      print "</td>";
    }
    print "<td class='abilities'>";
    #start @0 abilities
    my $count=0;

    #print abilities
    foreach (@abilities) {
      if ($_->{'level'}==$a) {
        #increment the abilities
        $count++;

        #comma seperate the abilities
        print ", " unless $count==1;
        
        my $name  = $_->{'name'};
        my $id    = $_->{'id'};
        print "<span class='ability'><a onclick='descriptionMouseOver($id)' href='javascript:void();'>$name</a>";
        #make the modifier string pretty if needed.
        if ($_->{'mod_string'}) {
          $_->{'mod_string'}=~s/\?/$_->{'modifier'}/g;
          $_->{'mod_string'}=~s/any per day/at will/g;
          print ": ",$_->{'mod_string'};
        }
        print "</span>";
      }
    }
  print "---&nbsp;" if $count==0;
  print "</td></tr>\n";
}

#end the table
print "</table>\n";

#generate info region

print "<div id='info'>\n";
my @list;
foreach my $item (@abilities) {
  my $id = $item->{'id'};

  #have I printed this one yet? lets not be wasteful
  unless(grep {$_ eq $id} @list) {
    push(@list,$id);
    my ($info, $name) = @{$item}{qw(description name)};
    $info =~ s/(\[\[class\]\])/$item->{'class'}/g;
    print "<div id='$id' style='display:none;' class='ability_info'><h3>$name</h3><p>$info</p></div>\n";
  }
}

print "</div>";
print $q->end_html();
