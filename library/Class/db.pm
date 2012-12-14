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

#--------------------------------#
#####+++++ Main Methods +++++#####
#--------------------------------#

sub user {

   my ($self, $type, @_args) = @_;
   my $queries = {
      user => "
         SELECT DISTINCT * 
         FROM users 
         WHERE name = (?)",

      sessioncheck => "
         SELECT * 
         FROM  `users` 
         WHERE session =  ?
         AND session_issue > ?",

      sessionupdate => "
         UPDATE  `sharef_dnd`.`users` 
         SET  `session` =  (?),
         `session_issue` =  (?) 
         WHERE  `users`.`name` = (?)
         AND `users`.`id` = (?)",
      
      'password reset' => "
         UPDATE sharef_dnd.users
         SET password = ?
         WHERE users.name = ?
         AND users.id = ?
         AND users.email = ?
         AND users.password = ?",
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


sub options {
   #Should accept (uid, option, [value])
   #If value, set option to value
   #otherwise display value
   my ($self, $user, $option, $value) = @_;
   my $queries = {
      get => "
         SELECT 
            o.option_value
         FROM user_options 
            AS o
         JOIN users AS u 
            ON u.id = o.user_id
         JOIN option_cataloge AS s 
            ON s.id = o.option_id
         WHERE u.name = ?
         AND s.option_name = ?",
      set => "UPDATE user_options AS o
         JOIN users AS u
            ON u.id = o.user_id
         JOIN option_cataloge AS s
            ON s.id = o.option_id
         SET option_value = ?
         WHERE u.name=?
         AND s.option_name = ?"
   };
   
   if ($value) {
      my $query = $self->cursor->prepare($queries->{set});
      if ( $query->execute($value,$user,$option) == 1 ) {
         return 1;
      } else {
         return;
      }
   } else {
      my $query = $self->cursor->prepare($queries->{get});
      $query->execute($user,$option);
      return @{$query->fetchrow_arrayref};
   } 

   
}
sub token {
   #method for manipulation and display of tokens 
   my ($self, $user, $action, @_args) = @_;
   my @flags = ('Register','GM','SGM','NPC');
   my $queries = {
      create => "
      INSERT INTO
         auth_codes
         (code, source, flag, notes)
      VALUES
         (?,?,?,?)",

      update => "
         UPDATE auth_codes AS code
         SET code.target = ?
         WHERE source.code =  ?
         AND code.code = ?
         AND code.target IS NULL",
      
      delete => "
         DELETE
         FROM
            auth_codes
         WHERE
            source = ?
         AND
            code = ?",
            
      owned => " 
         SELECT *
         FROM auth_codes
         WHERE source = ?",
         
       assigned => "
         SELECT *
         FROM auth_codes
         WHERE target = ?"
   };

   
   #input validation, user needs to exist, and $action must be a valid query key
   if ( ! $user ) { return; }
   if ( ! exists $queries->{$action} ) { return; }


   my $user_record = $self->user('user',$user);

   if ($action eq 'create') {
      #assumed @_args = flag[,notes])

      #generate the unique id
      my $code = uniqid;
      
      #validate the requested flag
      if (! $_args[1] ~~ @flags) { return }

      #validate the args length
      if ($#_args+1 < 2) { push @_args, '' };

      
      my $query = $self->cursor->prepare($queries->{create});
      if ($query->execute($code,$user_record->{id}, @_args) == 1) {

         #pull the now-owned list of tokens, and return the last element
         my @check = $self->token($user,'owned');
         
         #return the most recent token
         return $check[-1];
      }
      
   
   } elsif ($action ~~ {'owned','assigned'} ) {
      #owned and assigned tokens are handled the same, just knowing if source == user or target == user

      #prep and execute, no need to validate, as all input is already sanitized fully
      my $query = $self->cursor->prepare($queries->{$action});
      $query->execute($user_record->{id});

      #parse the DBI output into an array
      my @output;
      while ( my $row = $query->fetchrow_hashref) {
         push @output, $row;
      }
      #sort the array by the id number, so, chronologically
      my @output_sorted = sort { $a->{id} <=> $b->{id} } @output;
      return @output_sorted;

      
   } elsif ($action eq 'delete') {
      #accepts a code, verifies it is owned
      my $query = $self->cursor->prepare($queries->{delete});
      if ($query->execute($user_record->{id},$_args[0]) == 1) {
         return 1;
      } else {
         return;
      }
      
   } elsif ($action eq 'update') {
      #Class::db->token('user','update',code,target)
      my $query = $self->cursor->prepare($queries->{update});
      #translate the target name to a uid
      my $tid = $self->user('user',$_args[1])->{id};
      #run the update, if true, cool, otherwise, false
      if ($query->execute($tid,$user_record->{id},$_args[0]) == 1) {
         return 1;
      } else {
         return;
      }
   }
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
         (`name`, `password`, `salt`, `session`, `session_issue`, `email`, `games`)
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
         
         $_args->{'session_issue'} = time;

         #Behold, convoluted sessionid generation.  Instead of generating a random number, this effectivly guarntees unique sessionids
         $_args->{'session'} =  sha256_hex($_args->{'username'}.$_args->{'salt'}.$_args->{'session_issue'});
         

         #register the user
         $reg->execute(@{$_args}{'username', 'password', 'salt', 'session', 'session_issue', 'email', 'system'});
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
