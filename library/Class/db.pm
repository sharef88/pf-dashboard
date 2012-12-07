#!/usr/bin/perl
package db;
use Class;
use base qw/Class/;
use DBI;
use warnings;
use strict;
use Data::Dumper;
use Switch;


sub new {
   #un-repo'd file with the login info library/config.pm
   require config;

   my ($class,@_args) = @_;
   my $self = $class->SUPER::new(@_args);
   $self->cursor(DBI->connect("DBi:mysql:$config::db",$config::user,$config::pw, {AutoCommit => 1}));
   
}


sub DESTROY {

   #disconnect properly from the db
   my ( $self, @args ) = @_;

   $self->cursor->disconnect;

}


sub user {

   my ($self, $type, @_args) = @_;
   my $queries = {
      user => "
         SELECT DISTINCT * 
         FROM users 
         WHERE name = (?)",

      tokenupdate => "
         UPDATE  `sharef_dnd`.`users` 
         SET  `token` =  (?),
         `token_issue` =  (?) 
         WHERE  `users`.`name` = (?)
         AND `users`.`id` = (?)",

      'available tokens' => "
         SELECT 
            source, 
            code, 
            target, 
            flag
         FROM auth_codes
         JOIN users 
            ON users.id = auth_codes.source
         WHERE users.name = (?)
         AND target IS NULL",

      'owned tokens' => "
         SELECT 
            source, 
            code, 
            target, 
            flag
         FROM auth_codes
         JOIN users 
            ON users.id = auth_codes.target
         WHERE users.name = (?)"

   };

   if ( $type ) {
      if ( exists $queries->{$type} ) {

         my $query = $self->cursor->prepare( $queries->{$type} );
         my $out = ($query->execute(@_args)>=1) ? $query->fetchrow_hashref : {name=>'404'};
         return $out;
         
      } else { die('The '.$type.' query hasn\'t been set up yet') }
   } else { keys %$queries }
}

sub register {

   my ($self, $type, @_args) = @_;

   my $queries = {
      check => "
         SELECT 
            source, 
            code, 
            target, 
            flag
         FROM auth_codes
         JOIN users 
            ON users.id = auth_codes.source
         WHERE users.name = (?)
         AND code = (?)
         AND flag = 'Register'
         AND target IS NULL",

      create => "
         INSERT INTO `users`
         (`name`, `password`, `salt`, `token`, `token_issue`, `email`, `games`)
         VALUES ((?), (?), (?), (?), (?), (?), (?))"
   };
   if ( $type ) {
      if ( exists $queries->{$type} ) {
         my $restricted = {'create',1,'claim',1};
         if ( !(exists $restricted->{$type}) ) {
            my $query = $self->cursor->prepare( $queries->{$type} );
            my $out = ($query->execute(@_args)>=1) ? $query->fetchrow_hashref : {name=>'404'};
            return $out;
         } else { 
            die('cannot create yet')
         }
      } else { die('The '.$type.' query hasn\'t been set up yet') }
   } else { keys %$queries }
                           
}


sub class {
my($self, $type, @_args) = @_;


   #requires nothing, returns all classes with info 
   my $queries = { 
   classlist => 
      "SELECT DISTINCT 
         classes.name, 
         classes.id
      FROM classes
      JOIN arch_list 
         ON arch_list.base_id = classes.id
      JOIN class_abilities_levels 
         ON class_abilities_levels.class_id = arch_list.id;",
   
   #requires nothing, returns all archtypes with info
   archlist =>
      "SELECT DISTINCT 
         arch_list.name, 
         classes.name AS base, 
         arch_list.id 
      FROM arch_list
      JOIN class_abilities_levels 
         ON class_abilities_levels.class_id=arch_list.id
      JOIN classes 
         ON classes.id=arch_list.base_id;",
   
   #requires (arch_id, leve) returns all abilities
   abilities => 
      "SELECT 
         class_abilities_levels.level, 
         class_abilities.name,
         class_abilities_levels.modifier,
         class_abilities.mod_string, 
         class_abilities.description, 
         class_abilities.id AS id
      FROM class_abilities_levels
      JOIN arch_list 
         ON arch_list.id = class_abilities_levels.class_id
      JOIN class_abilities 
         ON class_abilities.id = class_abilities_levels.ability_id
      JOIN classes 
         ON arch_list.base_id = classes.id
      WHERE arch_list.id = (?)
      AND class_abilities_levels.level <= (?)
      ORDER BY arch_list.id ASC,
      class_abilities_levels.level ASC",
   
   #requires arch_id returns custom columns required for the class table
   columns =>
      "SELECT 
         ability_columns 
      FROM arch_list 
      WHERE arch_list.id = (?);",
   
   #requires an archtype id, returns the non-ability scores
   stats =>
      "SELECT *, classes.name AS base
      FROM classes
      JOIN arch_list 
         ON arch_list.base_id = classes.id
      WHERE arch_list.id = (?)"
   };




   #TODO error checking, default case

   if ( exists $queries->{$type} ) {
   
      my $query = $self->cursor->prepare( $queries->{$type} );
      $query->execute(@_args); 

      my @results;
      while ( my $row = $query->fetchrow_hashref ) {
         push @results, $row;
      }


      return \@results;
   } else { keys %$queries } 
}   

1;
