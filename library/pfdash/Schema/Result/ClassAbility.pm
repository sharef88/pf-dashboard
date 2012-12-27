use utf8;
package pfdash::Schema::Result::ClassAbility;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

pfdash::Schema::Result::ClassAbility

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<class_abilities>

=cut

__PACKAGE__->table("class_abilities");


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
  extra: {list => ["Ex","Su","Sp"]}
  is_nullable: 1

=head2 mod_string

  data_type: 'varchar'
  is_nullable: 0
  size: 20

=head2 description

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 0 },
  "type",
  {
    data_type => "enum",
    extra => { list => ["Ex", "Su", "Sp"] },
    is_nullable => 1,
  },
  "mod_string",
  { data_type => "varchar", is_nullable => 0, size => 20 },
  "description",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 class_abilities_levels

Type: has_many

Related object: L<pfdash::Schema::Result::ClassAbilitiesLevel>

=cut

__PACKAGE__->has_many(
  "class_abilities_levels",
  "pfdash::Schema::Result::ClassAbilitiesLevel",
  { "foreign.ability_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2012-12-26 14:13:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:X6U7wx+geatzxcpGfceAUQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration

__PACKAGE__->resultset_class( 'DBIx::Class::ResultSet::HashRef' );

1;
