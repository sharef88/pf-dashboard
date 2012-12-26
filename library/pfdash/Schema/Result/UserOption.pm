use utf8;
package pfdash::Schema::Result::UserOption;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

pfdash::Schema::Result::UserOption

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<user_options>

=cut

__PACKAGE__->table("user_options");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 option_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 option_index

  data_type: 'integer'
  is_nullable: 0

=head2 option_value

  data_type: 'varchar'
  is_nullable: 0
  size: 150

=head2 notes

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "option_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "option_index",
  { data_type => "integer", is_nullable => 0 },
  "option_value",
  { data_type => "varchar", is_nullable => 0, size => 150 },
  "notes",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<user_id_2>

=over 4

=item * L</user_id>

=item * L</option_id>

=item * L</option_index>

=back

=cut

__PACKAGE__->add_unique_constraint("user_id_2", ["user_id", "option_id", "option_index"]);

=head1 RELATIONS

=head2 option

Type: belongs_to

Related object: L<pfdash::Schema::Result::OptionCataloge>

=cut

__PACKAGE__->belongs_to(
  "option",
  "pfdash::Schema::Result::OptionCataloge",
  { id => "option_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 user

Type: belongs_to

Related object: L<pfdash::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "pfdash::Schema::Result::User",
  { id => "user_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2012-12-26 14:13:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:OraCDptWpOlIQ99OCgwksQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
