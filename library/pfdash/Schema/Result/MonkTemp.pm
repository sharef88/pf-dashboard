use utf8;
package pfdash::Schema::Result::MonkTemp;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

pfdash::Schema::Result::MonkTemp

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<monk_temp>

=cut

__PACKAGE__->table("monk_temp");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 class_id

  data_type: 'integer'
  is_nullable: 0

=head2 level

  data_type: 'integer'
  is_nullable: 0

=head2 ability_id

  data_type: 'integer'
  is_nullable: 0

=head2 modifier

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "class_id",
  { data_type => "integer", is_nullable => 0 },
  "level",
  { data_type => "integer", is_nullable => 0 },
  "ability_id",
  { data_type => "integer", is_nullable => 0 },
  "modifier",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2012-12-26 14:13:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:SMVc2YffCgskqDzKD9GiRQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
