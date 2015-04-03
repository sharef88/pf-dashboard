#!/usr/local/bin/perl
package db;

use warnings;
use strict;

use Class;
use base qw/Class/;

use DBI;
use Data::Dumper;
use Data::Uniqid qw/uniqid/;
use Digest::SHA 'sha256_hex';



sub new {
   #un-repo'd file with the login info library/config.pm
   require config;
   my ($class,@_args) = @_;
   my $self = $class->SUPER::new(@_args);
   $self->cursor(
      DBI->connect(
         "DBi:mysql:database=$config::db;host=$config::hostname",
         $config::user,
         $config::pw, 
         {AutoCommit => 0, ShowErrorStatement=>1}
      )
   );

   $self->cursor->{RaiseError} = 1;
   return $self;
   
}


sub DESTROY {
   #disconnect properly from the db
   my ( $self, @args ) = @_;
   $self->cursor->rollback;

   $self->cursor->disconnect;

}
1;
