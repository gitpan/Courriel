package Courriel::Types;
$Courriel::Types::VERSION = '0.36';
use strict;
use warnings;
use namespace::autoclean;

use parent 'MooseX::Types::Combine';

__PACKAGE__->provide_types_from(
    qw(
        MooseX::Types::Common::String
        MooseX::Types::Moose
        Courriel::Types::Internal
        )
);

1;
