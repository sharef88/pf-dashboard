use utf8;
package pfdash::Schema::Result::ActiveCharacter;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

pfdash::Schema::Result::ActiveCharacter

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<active_character>

=cut

__PACKAGE__->table("active_character");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 0

=head2 owner

  data_type: 'integer'
  is_nullable: 0

=head2 exp

  data_type: 'integer'
  is_nullable: 0

=head2 str

  data_type: 'integer'
  is_nullable: 0

=head2 dex

  data_type: 'integer'
  is_nullable: 0

=head2 con

  data_type: 'integer'
  is_nullable: 0

=head2 int

  data_type: 'integer'
  is_nullable: 0

=head2 wis

  data_type: 'integer'
  is_nullable: 0

=head2 cha

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 0 },
  "owner",
  { data_type => "integer", is_nullable => 0 },
  "exp",
  { data_type => "integer", is_nullable => 0 },
  "str",
  { data_type => "integer", is_nullable => 0 },
  "dex",
  { data_type => "integer", is_nullable => 0 },
  "con",
  { data_type => "integer", is_nullable => 0 },
  "int",
  { data_type => "integer", is_nullable => 0 },
  "wis",
  { data_type => "integer", is_nullable => 0 },
  "cha",
  { data_type => "integer", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 active_character_class

Type: might_have

Related object: L<pfdash::Schema::Result::ActiveCharacterClass>

=cut

__PACKAGE__->might_have(
  "active_character_class",
  "pfdash::Schema::Result::ActiveCharacterClass",
  { "foreign.character_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 active_inventories

Type: has_many

Related object: L<pfdash::Schema::Result::ActiveInventory>

=cut

__PACKAGE__->has_many(
  "active_inventories",
  "pfdash::Schema::Result::ActiveInventory",
  { "foreign.owner" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2012-12-26 14:13:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:nt/TQBSQO0oCNxJGOqGxNg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
