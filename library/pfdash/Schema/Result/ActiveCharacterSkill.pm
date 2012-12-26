use utf8;
package pfdash::Schema::Result::ActiveCharacterSkill;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

pfdash::Schema::Result::ActiveCharacterSkill

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<active_character_skills>

=cut

__PACKAGE__->table("active_character_skills");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 class_id

  data_type: 'integer'
  is_nullable: 0

=head2 arch_id

  data_type: 'integer'
  is_nullable: 0

=head2 skill_id

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "class_id",
  { data_type => "integer", is_nullable => 0 },
  "arch_id",
  { data_type => "integer", is_nullable => 0 },
  "skill_id",
  { data_type => "integer", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2012-12-26 14:13:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:xFkI9uA9P+ywE/HwjfmmZw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
