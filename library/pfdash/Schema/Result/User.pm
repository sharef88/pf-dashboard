use utf8;
package pfdash::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

pfdash::Schema::Result::User

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<users>

=cut

__PACKAGE__->table("users");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 200

=head2 password

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 salt

  data_type: 'text'
  is_nullable: 0

=head2 session

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 session_issue

  data_type: 'integer'
  is_nullable: 0

=head2 session_expiration

  data_type: 'integer'
  is_nullable: 0

=head2 email

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 200 },
  "password",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "salt",
  { data_type => "text", is_nullable => 0 },
  "session",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "session_issue",
  { data_type => "integer", is_nullable => 0 },
  "session_expiration",
  { data_type => "integer", is_nullable => 0 },
  "email",
  { data_type => "varchar", is_nullable => 1, size => 100 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<name>

=over 4

=item * L</name>

=back

=cut

__PACKAGE__->add_unique_constraint("name", ["name"]);

=head1 RELATIONS

=head2 auth_codes_sources

Type: has_many

Related object: L<pfdash::Schema::Result::AuthCode>

=cut

__PACKAGE__->has_many(
  "auth_codes_sources",
  "pfdash::Schema::Result::AuthCode",
  { "foreign.source" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 auth_codes_targets

Type: has_many

Related object: L<pfdash::Schema::Result::AuthCode>

=cut

__PACKAGE__->has_many(
  "auth_codes_targets",
  "pfdash::Schema::Result::AuthCode",
  { "foreign.target" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user_options

Type: has_many

Related object: L<pfdash::Schema::Result::UserOption>

=cut

__PACKAGE__->has_many(
  "user_options",
  "pfdash::Schema::Result::UserOption",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2012-12-26 14:13:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XVyzUSaQU/zuM42nadgShA


# You can replace this text with custom code or comments, and it will be preserved on regeneration

=head2 options

Type: many_to_many

=cut


__PACKAGE__->many_to_many(
   'options',
   'user_options',
   'option'
);
1;
