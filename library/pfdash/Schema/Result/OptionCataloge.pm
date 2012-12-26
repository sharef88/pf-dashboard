use utf8;
package pfdash::Schema::Result::OptionCataloge;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

pfdash::Schema::Result::OptionCataloge

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<option_cataloge>

=cut

__PACKAGE__->table("option_cataloge");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 option_name

  data_type: 'text'
  is_nullable: 0

=head2 option_count

  data_type: 'integer'
  is_nullable: 0

=head2 option_description

  data_type: 'text'
  is_nullable: 0

=head2 grouping

  data_type: 'enum'
  extra: {list => ["game","personal"]}
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "option_name",
  { data_type => "text", is_nullable => 0 },
  "option_count",
  { data_type => "integer", is_nullable => 0 },
  "option_description",
  { data_type => "text", is_nullable => 0 },
  "grouping",
  {
    data_type => "enum",
    extra => { list => ["game", "personal"] },
    is_nullable => 1,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 user_options

Type: has_many

Related object: L<pfdash::Schema::Result::UserOption>

=cut

__PACKAGE__->has_many(
  "user_options",
  "pfdash::Schema::Result::UserOption",
  { "foreign.option_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2012-12-26 14:13:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:7n7DJQo1NsXKeT1nGPoNKQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
