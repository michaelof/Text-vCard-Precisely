package Text::vCard::Precisely::V4::Node::Address;

use Carp;
use Moose;

extends qw|Text::vCard::Precisely::V3::Node::Address Text::vCard::Precisely::V4::Node|;

has name    => ( is => 'ro', default => 'ADR', isa => 'Str' );
has content => ( is => 'ro', default => '',    isa => 'Str' );

has label => ( is => 'rw', isa => 'Str' );
has geo   => ( is => 'rw', isa => 'Str' );
has tz    => ( is => 'rw', isa => 'Str' );

my @order = @Text::vCard::Precisely::V3::Node::Address::order;

override 'as_string' => sub {
    my ($self) = @_;
    my @lines = $self->name() || croak "Empty name";
    push @lines, 'ALTID=' . $self->altID() if $self->can('altID') and $self->altID();
    push @lines, 'PID=' . join ',', @{ $self->pid() } if $self->can('pid') and $self->pid();
    push @lines, 'TYPE="' . join( ',', map {uc} @{ $self->types() } ) . '"'
        if ref $self->types() eq 'ARRAY' and $self->types()->[0];
    push @lines, 'PREF=' . $self->pref()                            if $self->pref();
    push @lines, 'LANGUAGE=' . $self->language()                    if $self->language();
    push @lines, 'LABEL="' . $self->_escape( $self->label() ) . '"' if $self->label();
    push @lines, 'GEO="' . $self->geo() . '"'                       if $self->geo();
    push @lines, 'TZ=' . $self->tz()                                if $self->tz();

    my $string = join( ';', @lines ) . ':' . join ';', map { $self->_escape( $self->$_ ) } @order;
    return $self->fold($string);
};

__PACKAGE__->meta->make_immutable();
no Moose;

1;
