#!/usr/bin/perl
package config;

require DBI;
use warnings;
use strict;
use CGI;
my $q = CGI->new();


#where is the stuff?
my $host = "localhost";
my $database = "sharef_dnd";
my $tablename = "character";
my $user = "sharef_dnd";
my $pw = "penguin";

#connect to the stuff's home
our $cursor = DBI->connect("DBi:mysql:$database",$user,$pw, {AutoCommit => 1});
#$cursor->{HandleError} = sub { print die $_[0]}
$cursor->{HandleError} = sub { print $q->script("console.log('zomg the error is: $_[0]')"); };



=begin sql
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

my $class_meta_query = "SELECT *
FROM classes
JOIN arch_list ON arch_list.base_id = classes.id
WHERE arch_list.id = (?)";

#prepare the stuff (related to classes)
our $sql_class = $cursor->prepare($classquery);
our $sql_arch = $cursor->prepare($archquery);
our $sql_classes = $cursor->prepare($classlistquery);
our $sql_class_meta = $cursor->prepare($class_meta_query);
our $sql_arch_table = $cursor->prepare($arch_table_query);





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

our $sql_user = $cursor->prepare($userquery);
our $sql_token = $cursor->prepare($tokenupdate);
=end sql
=cut




1;
