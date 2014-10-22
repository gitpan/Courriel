package Courriel::Role::Streams;
$Courriel::Role::Streams::VERSION = '0.32';
use strict;
use warnings;
use namespace::autoclean;

use Courriel::Types qw( Streamable );
use MooseX::Params::Validate qw( validated_list );

use Moose::Role;

{
    my @spec = ( output => { isa => Streamable, coerce => 1 } );
    sub stream_to {
        my $self = shift;
        my ($output) = validated_list(
            \@_,
            @spec,
        );

        $self->_stream_to($output);

        return;
    }
}

sub as_string {
    my $self = shift;

    my $string = q{};

    $self->stream_to( output => $self->_string_output( \$string ) );

    return $string;
}

sub _string_output {
    my $self      = shift;
    my $stringref = shift;

    my $string = q{};
    return sub { ${$stringref} .= $_ for @_ };
}

1;
