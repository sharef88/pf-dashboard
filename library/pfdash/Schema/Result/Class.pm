use utf8;
package pfdash::Schema::Result::Class;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

pfdash::Schema::Result::Class

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<classes>

=cut

__PACKAGE__->table("classes");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 0

=head2 type

  data_type: 'enum'
  extra: {list => ["Base","Prestige"]}
  is_nullable: 0

=head2 hd

  data_type: 'integer'
  is_nullable: 0

=head2 bab

  data_type: 'integer'
  is_nullable: 0

=head2 will

  data_type: 'enum'
  extra: {list => ["good","poor"]}
  is_nullable: 0

=head2 fort

  data_type: 'enum'
  extra: {list => ["good","poor"]}
  is_nullable: 0

=head2 ref

  data_type: 'enum'
  extra: {list => ["good","poor"]}
  is_nullable: 0

=head2 skill

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 0 },
  "type",
  {
    data_type => "enum",
    extra => { list => ["Base", "Prestige"] },
    is_nullable => 0,
  },
  "hd",
  { data_type => "integer", is_nullable => 0 },
  "bab",
  { data_type => "integer", is_nullable => 0 },
  "will",
  {
    data_type => "enum",
    extra => { list => ["good", "poor"] },
    is_nullable => 0,
  },
  "fort",
  {
    data_type => "enum",
    extra => { list => ["good", "poor"] },
    is_nullable => 0,
  },
  "ref",
  {
    data_type => "enum",
    extra => { list => ["good", "poor"] },
    is_nullable => 0,
  },
  "skill",
  { data_type => "integer", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 active_character_classes

Type: has_many

Related object: L<pfdash::Schema::Result::ActiveCharacterClass>

=cut

__PACKAGE__->has_many(
  "active_character_classes",
  "pfdash::Schema::Result::ActiveCharacterClass",
  { "foreign.class_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 arch_lists

Type: has_many

Related object: L<pfdash::Schema::Result::ArchList>

=cut

__PACKAGE__->has_many(
  "arch_lists",
  "pfdash::Schema::Result::ArchList",
  { "foreign.base_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2012-12-28 15:11:22
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:LglXkn8anR6zbLLYlIGVlQ

__PACKAGE__->resultset_class( 'DBIx::Class::ResultSet::HashRef' );


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
