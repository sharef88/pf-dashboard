#!/usr/bin/perl
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
         "DBi:mysql:$config::db",
         $config::user,
         $config::pw, 
         {AutoCommit => 1}
      )
   );

   return $self;
   
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

      sessionupdate => "
         UPDATE  `sharef_dnd`.`users` 
         SET  `session` =  (?),
         `session_issue` =  (?) 
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
         $query->finish;
         return $out;
         
      } else { die('The '.$type.' query hasn\'t been set up yet') }
   } else { keys %$queries }
}

sub register {

   my ($self, $_args) = @_;

   my $queries = {
      check => "
         SELECT code.*
         FROM auth_codes AS code
         JOIN users AS s
            ON s.id = code.source
         WHERE s.name = (?)
         AND code.code = (?)
         AND code.flag = 'Register'
         AND code.target IS NULL",

      create => "
         INSERT INTO `users`
         (`name`, `password`, `salt`, `token`, `token_issue`, `email`, `games`)
         VALUES (?, ?, ?, ?, ?, ?, ?)",

      claim => "
         UPDATE auth_codes AS code
         JOIN users AS u
            ON u.id = code.source 
         SET code.target = ?
         WHERE u.name =  ? 
         AND code.code = ?
         AND code.target IS NULL",
         
      claimcheck => "
         SELECT code.* 
         FROM auth_codes AS code
         JOIN users AS u
            ON u.id = code.source
         WHERE code.target = ?
         AND u.name = ?
         AND code.code = ?",
   };
   my $check = $self->cursor->prepare( $queries->{'check'} );
  
   #does the user not exist yet?
   if ( $self->user('user',$_args->{'username'})->{'name'} ne $_args->{'username'} ) {
   
      #is the code valid?
      my $check = $self->cursor->prepare( $queries->{'check'} );
      if ( $check->execute(@{$_args}{'gm','auth'}) == 1 ) {

         #register that guy!
         my $reg = $self->cursor->prepare( $queries->{'create'} );
         

         #make salt
         $_args->{'salt'} = int(rand(2**32));
        
         if ($_args->{'password'} eq $_args->{'password2'}) {
            $_args->{'password'} = sha256_hex($_args->{password}.$_args->{'salt'});
         } else { die('Password mismatch') }
         
         $_args->{'token_issue'} = time;

         #Behold, convoluted token generation.  Instead of generating a random number, this effectivly guarntees unique tokens
         $_args->{'token'} =  sha256_hex($_args->{'username'}.$_args->{'salt'}.$_args->{'token_issue'});
         

         #register the user
         $reg->execute(@{$_args}{'username', 'password', 'salt', 'token', 'token_issue', 'email', 'system'});
         $reg->finish;
         my $registered = $self->user('user',$_args->{'username'});

         
         #prep the claim
         my $claim = $self->cursor->prepare( $queries->{'claim'} );

         #create the claim array
         my @array = ($registered->{'id'}, @{$_args}{'gm','auth'});

         #was the claim successful? should output a 1, to indicate 1 row changed
         if ( $claim->execute(@array) == 1 ) {

            #prep the claim-check, check allll the things!
            my $claimcheck = $self->cursor->prepare( $queries->{'claimcheck'} );
                     
            $claimcheck->execute(@array);
#            my $checked = $claimcheck->fetchrow_hashref;
#            $claimcheck->finish;
#            return $checked;
            return @{$self->user('user',$_args->{'username'})}{'session','session_issue'};
         #TODO replace die statements with (return err)
         } else { die('could not claim') }
      } else { die('code not valid') } 
   } else { die('user already exists') }
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
