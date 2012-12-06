package Class;
use Sub::Name;

sub new {
	my $class = shift;
	my $self  = {@_};
	return bless $self, $class;
}

sub AUTOLOAD {
	my ($self) = @_;

	our $AUTOLOAD;
	my $caller = caller;

	( my $variable = $AUTOLOAD ) =~ s/.*:://;

	*{"${caller}::${variable}"} = subname "${caller}::${variable}" => sub { return shift->{$variable} ||=$_[0] };
	return $self->{$variable} ||=$_[0];

}

sub DESTROY { }

1;
