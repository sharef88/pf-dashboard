use utf8;
package pfdash::Schema::Result::SkillCataloge;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

pfdash::Schema::Result::SkillCataloge

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<skill_cataloge>

=cut

__PACKAGE__->table("skill_cataloge");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 0

=head2 penalty

  data_type: 'tinyint'
  is_nullable: 0

=head2 attribute

  data_type: 'enum'
  extra: {list => ["str","dex","con","int","wis","cha"]}
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
  "penalty",
  { data_type => "tinyint", is_nullable => 0 },
  "attribute",
  {
    data_type => "enum",
    extra => { list => ["str", "dex", "con", "int", "wis", "cha"] },
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

=head2 class_skills

Type: has_many

Related object: L<pfdash::Schema::Result::ClassSkill>

=cut

__PACKAGE__->has_many(
  "class_skills",
  "pfdash::Schema::Result::ClassSkill",
  { "foreign.skill_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 sub_skill_cataloges

Type: has_many

Related object: L<pfdash::Schema::Result::SubSkillCataloge>

=cut

__PACKAGE__->has_many(
  "sub_skill_cataloges",
  "pfdash::Schema::Result::SubSkillCataloge",
  { "foreign.parent" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2012-12-28 15:11:22
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:kJRaTcMoTduGKo5UMAGdZQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
