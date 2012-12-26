use utf8;
package pfdash::Schema::Result::ItemModification;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

pfdash::Schema::Result::ItemModification

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<item_modifications>

=cut

__PACKAGE__->table("item_modifications");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 0

=head2 value

  data_type: 'text'
  is_nullable: 0

=head2 restrict

  data_type: 'set'
  extra: {list => ["armor","weapons","items"]}
  is_nullable: 0

=head2 description

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 0 },
  "value",
  { data_type => "text", is_nullable => 0 },
  "restrict",
  {
    data_type => "set",
    extra => { list => ["armor", "weapons", "items"] },
    is_nullable => 0,
  },
  "description",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 inventories_modify

Type: has_many

Related object: L<pfdash::Schema::Result::InventoryModify>

=cut

__PACKAGE__->has_many(
  "inventories_modify",
  "pfdash::Schema::Result::InventoryModify",
  { "foreign.modificationid" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2012-12-26 14:13:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:6bhXHsnbWEMJaNdnXLfbFg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
