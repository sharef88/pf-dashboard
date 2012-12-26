use utf8;
package pfdash::Schema::Result::ActiveCharacterClass;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

pfdash::Schema::Result::ActiveCharacterClass

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<active_character_classes>

=cut

__PACKAGE__->table("active_character_classes");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 character_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 class_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 arch_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 level

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "character_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "class_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "arch_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "level",
  { data_type => "integer", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<character_id>

=over 4

=item * L</character_id>

=back

=cut

__PACKAGE__->add_unique_constraint("character_id", ["character_id"]);

=head1 RELATIONS

=head2 arch

Type: belongs_to

Related object: L<pfdash::Schema::Result::ArchList>

=cut

__PACKAGE__->belongs_to(
  "arch",
  "pfdash::Schema::Result::ArchList",
  { id => "arch_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "RESTRICT" },
);

=head2 character

Type: belongs_to

Related object: L<pfdash::Schema::Result::ActiveCharacter>

=cut

__PACKAGE__->belongs_to(
  "character",
  "pfdash::Schema::Result::ActiveCharacter",
  { id => "character_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 class

Type: belongs_to

Related object: L<pfdash::Schema::Result::Class>

=cut

__PACKAGE__->belongs_to(
  "class",
  "pfdash::Schema::Result::Class",
  { id => "class_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2012-12-26 14:13:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:O4C1jlxXs9FQJh0mq9Y0ew


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
