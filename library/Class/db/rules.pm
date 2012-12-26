#!/usr/local/bin/perl
package rules;

use warnings;
use strict;

use Class::db;
use base qw/db/;




#--------------------------------#
#####+++++ Main Methods +++++#####
#--------------------------------#

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
   
   #requires nothing, returns all archtypes with base info
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
         class_abilities.id
      FROM class_abilities_levels
      JOIN arch_list 
         ON arch_list.id = class_abilities_levels.class_id
      JOIN class_abilities 
         ON class_abilities.id = class_abilities_levels.ability_id
      WHERE arch_list.id = (?)
      AND class_abilities_levels.level <= (?)
      ORDER BY class_abilities_levels.level ASC",
   
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
      #fetch-queries don't really require a transaction
      my $query = $self->cursor->prepare( $queries->{$type} );
      $query->execute(@_args); 
      return $query->fetchall_arrayref({});
   } else { keys %$queries } 
}   

1;
