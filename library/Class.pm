package Class;
use Sub::Name;

sub new {
	my $class = shift;
	my $self  = {@_};
	return bless $self, $class;
}

=broke
sub AUTOLOAD {
	my ($self) = @_;

	our $AUTOLOAD;
	my $caller = caller;

	( my $variable = $AUTOLOAD ) =~ s/.*:://;

	*{"${caller}::${variable}"} = subname "${caller}::${variable}" => sub { return shift->{$variable} ||=$_[0] };
	return $self->{$variable} ||=$_[0];

}

=cut
sub AUTOLOAD {
my ($self, $value) = @_;

our $AUTOLOAD;
   my ($caller,$variable) = ($AUTOLOAD =~ /^(.*)::(.*)$/);

   no strict qw(refs);
   *{"${caller}::${variable}"} = sub { 
      my ($self, $value ) = @_;
      $self->{$variable} = $value if defined $value;
      return $self->{$variable};
   };
   $self->{$variable} = $value if defined $value;
   return $self->{$variable};
}
sub DESTROY { }

1;
