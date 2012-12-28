use utf8;
package pfdash::Schema::Result::SubSkillCataloge;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

pfdash::Schema::Result::SubSkillCataloge

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<sub_skill_cataloge>

=cut

__PACKAGE__->table("sub_skill_cataloge");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'integer'
  is_nullable: 0

=head2 parent

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 description

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "integer", is_nullable => 0 },
  "parent",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
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

=head2 class_skills

Type: has_many

Related object: L<pfdash::Schema::Result::ClassSkill>

=cut

__PACKAGE__->has_many(
  "class_skills",
  "pfdash::Schema::Result::ClassSkill",
  { "foreign.sub_skill_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 parent

Type: belongs_to

Related object: L<pfdash::Schema::Result::SkillCataloge>

=cut

__PACKAGE__->belongs_to(
  "parent",
  "pfdash::Schema::Result::SkillCataloge",
  { id => "parent" },
  { is_deferrable => 1, on_delete => "NO ACTION", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2012-12-28 15:11:22
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:vtoJk2cQ5pT3cvPXg+V07Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
