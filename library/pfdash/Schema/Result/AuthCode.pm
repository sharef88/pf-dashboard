use utf8;
package pfdash::Schema::Result::AuthCode;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

pfdash::Schema::Result::AuthCode

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<auth_codes>

=cut

__PACKAGE__->table("auth_codes");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 source

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 code

  data_type: 'varchar'
  is_nullable: 0
  size: 15

=head2 target

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 flag

  data_type: 'enum'
  extra: {list => ["Register","GM","SGM","NPC"]}
  is_nullable: 0

=head2 notes

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "source",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "code",
  { data_type => "varchar", is_nullable => 0, size => 15 },
  "target",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "flag",
  {
    data_type => "enum",
    extra => { list => ["Register", "GM", "SGM", "NPC"] },
    is_nullable => 0,
  },
  "notes",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 source

Type: belongs_to

Related object: L<pfdash::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "source",
  "pfdash::Schema::Result::User",
  { id => "source" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 target

Type: belongs_to

Related object: L<pfdash::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "target",
  "pfdash::Schema::Result::User",
  { id => "target" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "SET NULL",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2012-12-26 14:13:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:doJD4Q/cW0Dbg0yty8aGjQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
