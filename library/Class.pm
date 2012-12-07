package Class;
use Sub::Name;

sub new {
	my $class = shift;
	my $self  = {@_};
	return bless $self, $class;
}

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
