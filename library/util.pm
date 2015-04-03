#!/usr/local/bin/perl
use strict;
use warnings;
use lib qw( library /home/sharef/perl5/lib/perl5/i686-linux /home/sharef/perl5/lib/perl5/i686-linux-thread-multi /home/sharef/perl5/lib/perl5 /var/www/pf.dash/library);

use DBI;
use Data::Dumper;
use List::Util qw/sum/;
use Digest::SHA 'sha256_hex';
use JSON::XS;

use config;

sub dice {
   my ($dice, $number) = @_;
   $number = 1 unless($_[1]);
   $dice = 20 unless($_[0]);
   my @result;
   foreach(1..$number){
      push @result,1+int(rand($dice+1));
   }
   sum(@result);
}



sub array_check {
   my ($check,@stuff) = @_;
   foreach (@stuff) {
      if ( $check == $_ ) {
         return 1;
      }
   }
}

sub salt {
   return (int(rand(100000))*314159);
}




1
