use utf8;
package pfdash::Schema::Result::ClassAbilitiesLevel;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

pfdash::Schema::Result::ClassAbilitiesLevel

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<class_abilities_levels>

=cut

__PACKAGE__->table("class_abilities_levels");
__PACKAGE__->resultset_class( 'DBIx::Class::ResultSet::HashRef' );


=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 class_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 level

  data_type: 'integer'
  is_nullable: 0

=head2 ability_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 modifier

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "class_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "level",
  { data_type => "integer", is_nullable => 0 },
  "ability_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "modifier",
  { data_type => "varchar", is_nullable => 0, size => 100 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<class_id_1>

=over 4

=item * L</class_id>

=item * L</level>

=item * L</ability_id>

=item * L</modifier>

=back

=cut

__PACKAGE__->add_unique_constraint("class_id_1", ["class_id", "level", "ability_id", "modifier"]);

=head1 RELATIONS

=head2 ability

Type: belongs_to

Related object: L<pfdash::Schema::Result::ClassAbility>

=cut

__PACKAGE__->belongs_to(
  "ability",
  "pfdash::Schema::Result::ClassAbility",
  { id => "ability_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "RESTRICT" },
);

=head2 class

Type: belongs_to

Related object: L<pfdash::Schema::Result::ArchList>

=cut

__PACKAGE__->belongs_to(
  "class",
  "pfdash::Schema::Result::ArchList",
  { id => "class_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2012-12-26 16:59:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:9fr7qHBKXyq6t8JZhDKuJw


# You can replace this text with custom code or comments, and it will be preserved on regeneration

__PACKAGE__->resultset_class( 'DBIx::Class::ResultSet::HashRef' );

1;
