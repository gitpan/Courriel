package Courriel::Types::Internal;
{
  $Courriel::Types::Internal::VERSION = '0.18';
}

use strict;
use warnings;
use namespace::autoclean;

use MooseX::Types -declare => [
    qw(
        Body
        EmailAddressStr
        EvenArrayRef
        Headers
        Part
        StringRef
        )
];

use MooseX::Types::Common::String qw( NonEmptyStr );
use MooseX::Types::Moose qw( ArrayRef HashRef ScalarRef Str );

#<<<
subtype Body,
    as role_type('Courriel::Role::Body');

subtype Headers,
    as class_type('Courriel::Headers');

subtype EmailAddressStr,
    as NonEmptyStr;

coerce EmailAddressStr,
    from class_type('Email::Address'),
    via { $_->format() };

subtype EvenArrayRef,
    as ArrayRef,
    where { @{$_} % 2 == 0 },
    message { 'The array reference must contain an even number of elements' };

coerce EvenArrayRef,
    from HashRef,
    via { %{@_} };

subtype Part,
    as role_type('Courriel::Role::Part');

subtype StringRef,
    as ScalarRef[Str];

coerce StringRef,
    from Str,
    via { my $str = $_; \$str };
#>>>
1;
