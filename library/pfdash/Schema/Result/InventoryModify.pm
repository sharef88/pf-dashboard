use utf8;
package pfdash::Schema::Result::InventoryModify;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

pfdash::Schema::Result::InventoryModify

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<inventory_modify>

=cut

__PACKAGE__->table("inventory_modify");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 itemid

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 modificationid

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "itemid",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "modificationid",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 itemid

Type: belongs_to

Related object: L<pfdash::Schema::Result::ActiveInventory>

=cut

__PACKAGE__->belongs_to(
  "itemid",
  "pfdash::Schema::Result::ActiveInventory",
  { id => "itemid" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "RESTRICT" },
);

=head2 modificationid

Type: belongs_to

Related object: L<pfdash::Schema::Result::ItemModification>

=cut

__PACKAGE__->belongs_to(
  "modificationid",
  "pfdash::Schema::Result::ItemModification",
  { id => "modificationid" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2012-12-26 14:13:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:9J3yVFQoQFKv+TyX8NZw/Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
