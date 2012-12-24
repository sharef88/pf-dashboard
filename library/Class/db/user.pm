#!/usr/local/bin/perl
package user;

use warnings;
use strict;

use Class::db;
use base qw/db/;

use Apache::DBI;
use DBI;
use Data::Dumper;
use Data::Uniqid qw/uniqid/;
use Digest::SHA 'sha256_hex';



sub new {
   my ($class,$_args) = @_;

   my $self = $class->SUPER::new;
   
   my $check=1;
   if ( defined $_args->{name} ) {
      $check = $self->user('user',$_args->{name});
   } elsif (defined $_args->{session} ) {
      $check = $self->user('sessioncheck',@{$_args}{'session'});
   }
   
   if ( $check ) {
      if ( exists $check->{password} ) {
         map  $self->{$_} = $check->{$_}, keys %$check;
      }
      return $self;
   } else {
      return;
   }

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

      id => "
         SELECT DISTINCT *
         FROM users
         WHERE id = ?",

      list => "
         SELECT DISTINCT 
            name, email
         FROM users",

      sessioncheck => "
         SELECT * 
         FROM  `users` 
         WHERE session =  ?",

      sessionupdate => "
         UPDATE users 
         SET  session = ?,
         session_issue = ? 
         WHERE users.name = ?
         AND users.id = ?",
      
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
         my $check = $query->execute(@_args);
         my $out;
         if ( $type ~~ ['sessionupdate','password reset'] ) {
            $self->cursor->commit;
            return 1;
         };
                     
         if ( $check == 1) {
            $out = $query->fetchrow_hashref; 
         } elsif ($check > 1) {
            $out = $query->fetchall_arrayref({}); 
         } else { 
            $out = {name=>'404'};
         }
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
            o.id,
            u.name,
            s.option_name,
            o.option_value
         FROM user_options 
            AS o
         JOIN users AS u 
            ON u.id = o.user_id
         JOIN option_cataloge AS s 
            ON s.id = o.option_id
         WHERE u.name = ?
         AND s.option_name = ?",
      set => "
         INSERT INTO user_options
            (user_id, option_id, option_value) 
         VALUES 
            (
               (SELECT id FROM users WHERE name = ?),
               (SELECT id FROM option_cataloge WHERE option_name = ?),
               ?
            )
         ON DUPLICATE KEY UPDATE 
            option_value=?"
   };
   
   #if there isn't a value to set, then just get the current value
   if ($value) {
      eval {
         my $query = $self->cursor->prepare($queries->{set});
         $query->execute($user,$option,$value,$value) or die; 
      };
      if ($@) {
         warn "could not set $option to $value because of $@";
         $self->cursor->rollback;
      } else {
         $self->cursor->commit;
         return 1;
      }
   } else {
      my $query = $self->cursor->prepare($queries->{get});
      $query->execute($user,$option);
      return $query->fetchall_arrayref({});
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
         SELECT 
            codes.id, 
            s.name AS source_name, 
            t.name AS target_name, 
            codes.code, 
            codes.flag,
            codes.source AS source_id,
            codes.target AS target_id,
            codes.notes
         FROM auth_codes as codes
         JOIN users AS s
            ON s.id = codes.source
         LEFT JOIN users AS t
            ON t.id = codes.target
         WHERE source = ?
         ORDER BY codes.id ASC",
               
       assigned => "
         SELECT 
            codes.id, 
            s.name AS source_name, 
            t.name AS target_name, 
            codes.code, 
            codes.flag,
            codes.source AS source_id,
            codes.target AS target_id,
            codes.notes
         FROM auth_codes as codes
         JOIN users AS t
            ON t.id = codes.target
         LEFT JOIN users AS s
            ON s.id = codes.source
         WHERE codes.target = ?
         ORDER BY codes.id ASC"
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
      
   
   } elsif ($action ~~ ['owned','assigned'] ) {
      #owned and assigned tokens are handled the same, just knowing if source == user or target == user

      #prep and execute, no need to validate, as all input is already sanitized fully
      my $query = $self->cursor->prepare($queries->{$action});
      $query->execute($user_record->{id});
      return @{$query->fetchall_arrayref({})};

      
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
         
         #transactionally register that guy and claim the token.
         eval {
            #turn on the ability to transact db-style
            $reg->execute(@{$_args}{'username', 'password', 'salt', 'session', 'session_issue', 'email', 'system'});
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
            } else { die('could not claim') }
         };
         if ($@) {
            warn "Transaction aborted because $@";
            # now rollback to undo the incomplete changes
            # but do it in an eval{} as it may also fail
            eval { $self->cursor->rollback };
         } else {
            $self->cursor->commit;
            return @{$self->user('user',$_args->{'username'})}{'session','session_issue'}; 
         }
         #TODO replace die statements with (return err) AND switch this to transaction format
      } else { die('code not valid') } 
   } else { die('user already exists') }
}
1;
