use utf8;
package pfdash::Schema::Result::ClassSkill;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

pfdash::Schema::Result::ClassSkill

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<class_skills>

=cut

__PACKAGE__->table("class_skills");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 arch_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 skill_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 sub_skill_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "arch_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "skill_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "sub_skill_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 arch

Type: belongs_to

Related object: L<pfdash::Schema::Result::ArchList>

=cut

__PACKAGE__->belongs_to(
  "arch",
  "pfdash::Schema::Result::ArchList",
  { id => "arch_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "RESTRICT" },
);

=head2 skill

Type: belongs_to

Related object: L<pfdash::Schema::Result::SkillCataloge>

=cut

__PACKAGE__->belongs_to(
  "skill",
  "pfdash::Schema::Result::SkillCataloge",
  { id => "skill_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "RESTRICT" },
);

=head2 sub_skill

Type: belongs_to

Related object: L<pfdash::Schema::Result::SubSkillCataloge>

=cut

__PACKAGE__->belongs_to(
  "sub_skill",
  "pfdash::Schema::Result::SubSkillCataloge",
  { id => "sub_skill_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "RESTRICT",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2012-12-28 15:11:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:DJDl9FcFCsawNzYL3JLIfg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
