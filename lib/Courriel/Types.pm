package Courriel::Types;
BEGIN {
  $Courriel::Types::VERSION = '0.01';
}

use strict;
use warnings;
use namespace::autoclean;

use base 'MooseX::Types::Combine';

__PACKAGE__->provide_types_from(
    qw(
        MooseX::Types::Common::String
        MooseX::Types::Moose
        Courriel::Types::Internal
        )
);

1;
