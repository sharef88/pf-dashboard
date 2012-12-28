use utf8;
package pfdash::Schema::Result::ArchList;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

pfdash::Schema::Result::ArchList

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<arch_list>

=cut

__PACKAGE__->table("arch_list");
__PACKAGE__->resultset_class( 'DBIx::Class::ResultSet::HashRef' );


=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 0

=head2 base_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 cast_type

  data_type: 'enum'
  extra: {list => ["divine","arcane","psionic","incarnum","martial"]}
  is_nullable: 1

=head2 cast_attribute

  data_type: 'enum'
  extra: {list => ["str","dex","con","int","wis","cha"]}
  is_nullable: 1

=head2 cast_storage

  data_type: 'enum'
  extra: {list => ["innate","pray","book","psi"]}
  is_nullable: 1

=head2 ability_columns

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 0 },
  "base_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "cast_type",
  {
    data_type => "enum",
    extra => { list => ["divine", "arcane", "psionic", "incarnum", "martial"] },
    is_nullable => 1,
  },
  "cast_attribute",
  {
    data_type => "enum",
    extra => { list => ["str", "dex", "con", "int", "wis", "cha"] },
    is_nullable => 1,
  },
  "cast_storage",
  {
    data_type => "enum",
    extra => { list => ["innate", "pray", "book", "psi"] },
    is_nullable => 1,
  },
  "ability_columns",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 active_character_classes

Type: has_many

Related object: L<pfdash::Schema::Result::ActiveCharacterClass>

=cut

__PACKAGE__->has_many(
  "active_character_classes",
  "pfdash::Schema::Result::ActiveCharacterClass",
  { "foreign.arch_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 base

Type: belongs_to

Related object: L<pfdash::Schema::Result::Class>

=cut

__PACKAGE__->belongs_to(
  "base",
  "pfdash::Schema::Result::Class",
  { id => "base_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "RESTRICT" },
  {cache=>1},
);

=head2 class_abilities_levels

Type: has_many

Related object: L<pfdash::Schema::Result::ClassAbilitiesLevel>

=cut

__PACKAGE__->has_many(
  "class_abilities_levels",
  "pfdash::Schema::Result::ClassAbilitiesLevel",
  { "foreign.class_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 class_skills

Type: has_many

Related object: L<pfdash::Schema::Result::ClassSkill>

=cut

__PACKAGE__->has_many(
  "class_skills",
  "pfdash::Schema::Result::ClassSkill",
  { "foreign.arch_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2012-12-26 14:13:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1OGR1RRqXUE2lzm9kz0m0g


# You can replace this text with custom code or comments, and it will be preserved on regeneration

__PACKAGE__->resultset_class( 'DBIx::Class::ResultSet::HashRef' );

=head2 abilities

Type: many_to_many

=cut

__PACKAGE__->many_to_many(
  ability_list=>'class_abilities_levels',
  'ability',
  {
     '+select'=>[qw/me.modifier me.level/],
     '+as'=>[qw/modifier level/]
  }
);



=head1 METHODS

=head2 stats

Args: Array of int.

Prefered usage: stats(1..20).

Return: Array of hashref with keys [bab, fort, ref, will].
=cut

sub stats {
   #can take 1-many number, preferred format $self->stats(1..20)
   my ($self, @_args) = @_;
   my @result;
   my $base = $self->base;

   #loop through the levels given
   foreach my $level (@_args){
      my $out = {};

      $out->{bab} = int $base->bab*($level/100);

      my %callbacks = (
         good => sub { int ( $level / 2 ) + 2 }, 
         poor => sub { int $level / 3 }
      );

      map { $out->{$_} = $callbacks{$base->$_}->() } 
         (qw/fort ref will/);

      push @result, $out;
   }
   return @result
}

=head2 abilities

Args: Array of int.

Prefered usage: abilities(1..20).

Return: LevelArray of arrays of hashref with keys [id, name, type, description, mod_string, modifier].
=cut

sub abilities {
   #can take 1-many number, preferred format $self->abilities(1..20)
   my ($self, @_args) = @_;
   my @result;
   my @abl_list = $self->ability_list->hashref_rs->all;
   my $class = $self->base->name;

   #loop through the levels given
   foreach my $level (@_args){
      my @out;
      foreach my $raw (@abl_list) {
         if ($level == $raw->{level}) {
            my $abl;
            #replace ? with the modifier number
            $raw->{'mod_string'} =~ s/\?/$raw->{'modifier'}/go;
            #if previous regex makes bad grammar, fix it
            $raw->{'mod_string'} =~ s/any per day/at will/go;
            
            map { $abl->{$_} = $raw->{$_} } 
               (qw/id name type description mod_string modifier/);

            #replace [[class]] with classname
            $abl->{description} =~ s/(\[\[class\]\])/\l$class\E/go;
            #replace [[Class]] with Classname
            $abl->{description} =~ s/(\[\[Class\]\])/\u$class\E/go;
            push @out, $abl;
         }
      }
      push @result, \@out;
   }
   return @result
}

1;
