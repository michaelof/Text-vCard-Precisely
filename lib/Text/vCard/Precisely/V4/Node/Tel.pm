package Text::vCard::Precisely::V4::Node::Tel;

use Carp;

use Moose;
use Moose::Util::TypeConstraints;

extends qw|Text::vCard::Precisely::V3::Node::Tel Text::vCard::Precisely::V4::Node|;

subtype 'v4Tel'
    => as 'Str'
    => where { m/^(?:tel:)?(?:[+]?\d{1,2}|\d*)[\(\s\-]?\d{1,3}[\)\s\-]?[\s]?\d{1,3}[\s\-]?\d{3,4}$/s }
    => message { "The Number you provided, $_, was not supported in Tel" };
has content => (is => 'ro', default => '', isa => 'v4Tel' );

override 'as_string' => sub {
    my ($self) = @_;
    my @lines;
    push @lines, $self->name || croak "Empty name";
    push @lines, 'ALTID=' . $self->altID if $self->altID;
    push @lines, 'PID=' . join ',', @{ $self->pid } if $self->pid;
    push @lines, 'TYPE=' . join( ',', map { uc $_ } @{ $self->types } ) if @{ $self->types || [] } > 0;
    push @lines, 'VALUE=uri';

    ( my $content = $self->content() ) =~ s/^\s+//s;    # remove top space
    $content =~ s/^tel:\(?//s;                          # remove tel: once
    $content =~ s/(?:(?!\A)\D|\()+/ /sg;                # replace symbols to space
    $content =~ s/^\s+//s;                              # remove top space again
    my $string = join(';', @lines ) . ':tel:' . $content;
    return $self->fold( $string, -force => 1 );
};



__PACKAGE__->meta->make_immutable;
no Moose;

1;
