use utf8;
package pfdash::Schema::Result::Talent;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

pfdash::Schema::Result::Talent - barbarian rage powers/rogue talents/other similar abilities

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<talents>

=cut

__PACKAGE__->table("talents");

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

=head2 description

  data_type: 'text'
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
    extra => { list => ["Ex", "Su", "Sp"] },
    is_nullable => 1,
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

=head2 talent_requirements

Type: has_many

Related object: L<pfdash::Schema::Result::TalentRequirement>

=cut

__PACKAGE__->has_many(
  "talent_requirements",
  "pfdash::Schema::Result::TalentRequirement",
  { "foreign.talent" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2012-12-26 14:13:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:kX4lT7EXiC/r7sAR8WU4rw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
