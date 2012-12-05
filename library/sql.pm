#!/usr/bin/perl
package sql;

require DBI;
use warnings;
use strict;
use CGI;
my $q = CGI->new();

#get the config, which also inits the cursor
require library::config;



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
our $sql_class = $config::cursor->prepare($classquery);
our $sql_arch = $config::cursor->prepare($archquery);
our $sql_classes = $config::cursor->prepare($classlistquery);
our $sql_class_meta = $config::cursor->prepare($class_meta_query);
our $sql_arch_table = $config::cursor->prepare($arch_table_query);





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

our $sql_user = $config::cursor->prepare($userquery);
our $sql_token = $config::cursor->prepare($tokenupdate);
our $sql_auth = $config::cursor->prepare($registerquery);
our $sql_create_user = $config::cursor->prepare($usercreate);








1;
