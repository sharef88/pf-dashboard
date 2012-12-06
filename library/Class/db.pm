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
   
#   $self->sql_token($self->cursor->prepare($tokenupdate));
#   $self->sql_auth($self->cursor->prepare($registerquery));
#   $self->sql_create_user($self->cursor->prepare($usercreate));

   
   return $self;
}

sub user {

   my ($self, $query) = @_;
   my $userquery = "
   SELECT DISTINCT * 
   FROM users 
   WHERE name = (?)";
   my $prep = $self->cursor->prepare($userquery);
   
   my $out = ($prep->execute($query)>=1) ? $prep->fetchrow_hashref : {name=>'404'};
   
   $prep->finish;
   
   return $out;

}
   

sub class {
   my($self, $type, @_args) = @_;


   #requires nothing, returns all classes with info 
   my $classlistquery = $self->cursor->prepare(
      "SELECT DISTINCT 
         classes.name, 
         classes.id
      FROM classes
      JOIN arch_list 
         ON arch_list.base_id = classes.id
      JOIN class_abilities_levels 
         ON class_abilities_levels.class_id = arch_list.id;"
   );
   
   #requires nothing, returns all archtypes with info
   my $archquery = $self->cursor->prepare(
      "SELECT DISTINCT 
         arch_list.name, 
         classes.name AS base, 
         arch_list.id 
      FROM arch_list
      JOIN class_abilities_levels 
         ON class_abilities_levels.class_id=arch_list.id
      JOIN classes 
         ON classes.id=arch_list.base_id;"
   );
   
   #requires (arch_id, leve) returns all abilities
   my $classquery = $self->cursor->prepare(
      "SELECT 
         class_abilities_levels.level, 
         class_abilities.name,
         class_abilities_levels.modifier,
         class_abilities.mod_string, 
         classes.name AS class, 
         arch_list.name AS arch, 
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
      class_abilities_levels.level ASC"
   );
   
   #requires arch_id returns custom columns required for the class table
   my $arch_table_query = $self->cursor->prepare(
      "SELECT 
         ability_columns 
      FROM arch_list 
      WHERE arch_list.id = (?);"
   );
   
   #requires an archtype id, returns the non-ability scores
   my $class_meta_query = $self->cursor->prepare(
      "SELECT *
      FROM classes
      JOIN arch_list 
         ON arch_list.base_id = classes.id
      WHERE arch_list.id = (?)"
   );

   #TODO error checking, default case
   switch ($type) {
      case 'classlist' {
         $classlistquery->execute();

         my @classlist;
         while ( my $item = $classlistquery->fetchrow_hashref() ) {
            push( @classlist, $item );
         }
         $classlistquery->finish;
         return @classlist;
      }
      case 'archlist' {
         $archquery->execute();

         my @archlist;
         while ( my $item = $archquery->fetchrow_hashref() ) {
            push( @archlist, $item );
         }
         $archquery->finish;
         return @archlist;
      }
      case 'class_meta' {
         #requires an arch_id
         $class_meta_query->execute($_args[0]);

         my @meta_list;
         while ( my $row = $class_meta_query->fetchrow_hashref() ) {
            push @meta_list, $row ;
         }
         $class_meta_query->finish;
         return @meta_list;
      }
      case 'abilities' {
         #requires an arch_id and a level
         $classquery->execute($_args[0],$_args[1]);
         my @abilities;
         while (my $row =  $classquery->fetchrow_hashref() ) {
            push @abilities, $row;            
         }
         #TODO should move the regex to this chunk
         $classquery->finish;
         return @abilities;
      }
      case 'columns' {
         #requires an arch_id
         $arch_table_query->execute($_args[0]);
         return $arch_table_query;
      }
   }
}   










=pod
#queries to query the database of stuff related to classes
my $classlistquery = "SELECT DISTINCT classes.name, classes.id
FROM classes
JOIN arch_list ON arch_list.base_id=classes.id
JOIN class_abilities_levels ON class_abilities_levels.class_id=arch_list.id;";

my $archquery = "SELECT DISTINCT arch_list.name, classes.name AS base, arch_list.id FROM arch_list
JOIN class_abilities_levels ON class_abilities_levels.class_id=arch_list.id
JOIN classes ON classes.id=arch_list.base_id;";

my $classquery = "SELECT class_abilities_levels.level, class_abilities.name,class_abilities_levels.modifier,class_abilities.mod_string, classes.name AS class, arch_list.name AS arch, class_abilities.description, class_abilities.id AS id
FROM class_abilities_levels
JOIN arch_list ON arch_list.id = class_abilities_levels.class_id
JOIN class_abilities ON class_abilities.id = class_abilities_levels.ability_id
JOIN classes ON arch_list.base_id = classes.id
WHERE arch_list.id = (?)
AND class_abilities_levels.level <= (?)
ORDER BY arch_list.id ASC,
class_abilities_levels.level ASC";

my $arch_table_query = "SELECT ability_columns FROM arch_list WHERE arch_list.id = (?);";

my $class_meta_query = "
SELECT *
FROM classes
JOIN arch_list ON arch_list.base_id = classes.id
WHERE arch_list.id = (?)";

#prepare the stuff (related to classes)
#our $sql_class = $config::cursor->prepare($classquery);
#our $sql_arch = $config::cursor->prepare($archquery);
#our $sql_classes = $config::cursor->prepare($classlistquery);
#our $sql_class_meta = $config::cursor->prepare($class_meta_query);
#our $sql_arch_table = $config::cursor->prepare($arch_table_query);





#now make strings related to users

my $userquery = "
SELECT DISTINCT * 
FROM users 
WHERE name = (?)";

my $tokenupdate = "
UPDATE  `sharef_dnd`.`users` 
SET  `token` =  (?),
`token_issue` =  (?) 
WHERE  `users`.`name` = (?)
AND `users`.`id` = (?)";

my $registerquery = "
SELECT source, code, target, flag
FROM auth_codes
JOIN users ON users.id = auth_codes.source
WHERE users.name = (?)
AND code = (?)
AND flag = 'Register'
AND target IS NULL";


my $usercreate = " INSERT INTO `users`
(`name`, `password`, `salt`, `token`, `token_issue`, `email`, `games`)
VALUES ((?), (?), (?), (?), (?), (?), (?))";

#our $sql_user = $config::cursor->prepare($userquery);
#our $sql_token = $config::cursor->prepare($tokenupdate);
#our $sql_auth = $config::cursor->prepare($registerquery);
#our $sql_create_user = $config::cursor->prepare($usercreate);







=cut
1;
