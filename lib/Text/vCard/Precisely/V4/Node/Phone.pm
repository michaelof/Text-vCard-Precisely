package Text::vCard::Precisely::V4::Node::Phone;

use Carp;

use Moose;
use Moose::Util::TypeConstraints;

extends 'Text::vCard::Precisely::V3::Node::Phone';

subtype 'v4Phone'
    => as 'Str'
    => where { m/^(:?tel:)?(:?[+]?\d{1,2}|\d*)[\(\s\-]?\d{1,3}[\)\s\-]?[\s]?\d{1,3}[\s\-]?\d{3,4}$/s }
    => message { "The Number you provided, $_, was not supported in Phone" };
has value => (is => 'ro', default => '', isa => 'v4Phone' );

override 'as_string' => sub {
    my ($self) = @_;
    my @lines;
    push @lines, $self->name || croak "Empty name";
    push @lines, 'TYPE=' . join( ',', map { uc $_ } @{ $self->types } ) if @{ $self->types || [] } > 0;
    push @lines, 'ALTID=' . $self->altID if $self->altID;
    push @lines, 'PID=' . join ',', @{ $self->pid } if $self->pid;
    push @lines, 'VALUE=uri';

    ( my $value = $self->value ) =~ s/[-+()\s]+/ /sg;   # symbols to space
    $value =~ s/^\s+//s;                                # remove top space
    $value =~ s/^(:?tel\:)//s;                          # remove top 'tel:' once
    my $string = join(';', @lines ) . ':tel:' . $value;
    return $self->fold( $string, -force => 1 );
};



__PACKAGE__->meta->make_immutable;
no Moose;

1;