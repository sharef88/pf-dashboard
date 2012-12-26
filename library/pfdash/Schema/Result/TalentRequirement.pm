use utf8;
package pfdash::Schema::Result::TalentRequirement;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

pfdash::Schema::Result::TalentRequirement

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<talent_requirements>

=cut

__PACKAGE__->table("talent_requirements");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 talent

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 type

  data_type: 'enum'
  extra: {list => ["talent","attributes","levels"]}
  is_nullable: 0

=head2 requirement

  data_type: 'integer'
  is_nullable: 0

=head2 level

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "talent",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "type",
  {
    data_type => "enum",
    extra => { list => ["talent", "attributes", "levels"] },
    is_nullable => 0,
  },
  "requirement",
  { data_type => "integer", is_nullable => 0 },
  "level",
  { data_type => "integer", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 talent

Type: belongs_to

Related object: L<pfdash::Schema::Result::Talent>

=cut

__PACKAGE__->belongs_to(
  "talent",
  "pfdash::Schema::Result::Talent",
  { id => "talent" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2012-12-26 14:13:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:TK86hLicigyKWHOxuy7obg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
