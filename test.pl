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

#my $info = $stuff->user('available tokens','NPC');
my $test = $stuff->register({
register=>'true',
username=>'sharef',
password=>'7da63a1f4cb36fdb5d58bbfbdfbbfb5cc05661e5bd4f3a91eb4ba16146e71c8b',
password2=>'7da63a1f4cb36fdb5d58bbfbdfbbfb5cc05661e5bd4f3a91eb4ba16146e71c8b',
email=>'gamerzi%40gmail.com',
gm=>'NPC',
auth=>'1537',
character=>'sharef',
system=>'pf'
});

print Dumper($test);

