package Courriel::Header;
{
  $Courriel::Header::VERSION = '0.26';
}

use strict;
use warnings;
use namespace::autoclean;

use Courriel::Helpers qw( fold_header );
use Courriel::Types qw( NonEmptyStr Str );
use Encode qw( encode find_encoding );
use MIME::Base64 qw( encode_base64 );
use MooseX::Params::Validate qw( validated_list );

use Moose;
use MooseX::StrictConstructor;

has name => (
    is       => 'ro',
    isa      => NonEmptyStr,
    required => 1,
);

has value => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

{
    my @spec = (
        charset => { isa => NonEmptyStr, default => 'utf8' },
    );

    sub as_header_string {
        my $self = shift;
        my ($charset) = validated_list(
            \@_,
            @spec
        );

        my $string = $self->name();
        $string .= ': ';

        $string .= $self->_maybe_encoded_value($charset);

        return fold_header($string);
    }
}

{
    my $header_chunk = qr/
                             (?:
                                 (?<ascii>[\x21-\x7e]+)   # printable ASCII (excluding space, \x20)
                             |
                                 (?<non_ascii>\S+)        # anything that's not space
                             )
                             (?:
                                 (?<ws>\s+)
                             |
                                 $
                             )
                         /x;

    # XXX - this really isn't very correct. Only certain types of values (per RFC
    # 2047) can be encoded, not just any random text. I'm not sure how best to
    # handle this. If we parsed an email that encoded stuff that shouldn't be
    # encoded, what should we do? At the very least, we should add some checks to
    # Courriel::Builder to ensure that people don't try to create an email with
    # non-ASCII in certain parts of fields (like in email addresses).
    sub _maybe_encoded_value {
        my $self    = shift;
        my $charset = shift;

        my $value = $self->value();
        my @chunks;

        while ( $value =~ /\G$header_chunk/g ) {
            push @chunks, {%+};
        }

        my @values;
        for my $i ( 0 .. $#chunks ) {
            if ( defined $chunks[$i]->{non_ascii} ) {
                my $to_encode
                    = $chunks[ $i + 1 ]
                    && defined $chunks[ $i + 1 ]{non_ascii}
                    ? $chunks[$i]{non_ascii} . ( $chunks[$i]{ws} // q{} )
                    : $chunks[$i]{non_ascii};

                push @values, $self->_mime_encode( $to_encode, $charset );
                push @values, q{ } if $chunks[ $i + 1 ];
            }
            else {
                push @values, $chunks[$i]{ascii} . ( $chunks[$i]{ws} // q{} );
            }
        }

        return join q{}, @values;
    }
}

sub _mime_encode {
    my $self    = shift;
    my $text    = shift;
    my $charset = find_encoding(shift)->mime_name();

    my $head = '=?' . $charset . '?B?';
    my $tail = '?=';

    my $base_length = 75 - ( length($head) + length($tail) );

    # This code is copied from Mail::Message::Field::Full in the Mail-Box
    # distro.
    my $real_length = int( $base_length / 4 ) * 3;

    my @result;
    my $chunk = q{};
    while ( length( my $chr = substr( $text, 0, 1, '' ) ) ) {
        my $chr = encode( $charset, $chr, 0 );

        if ( length($chunk) + length($chr) > $real_length ) {
            push @result, $head . encode_base64( $chunk, q{} ) . $tail;
            $chunk = q{};
        }

        $chunk .= $chr;
    }

    push @result, $head . encode_base64( $chunk, q{} ) . $tail
        if length $chunk;

    return join q{ }, @result;
}

__PACKAGE__->meta()->make_immutable();

1;

# ABSTRACT: A single header's name and value



=pod

=head1 NAME

Courriel::Header - A single header's name and value

=head1 VERSION

version 0.26

=head1 SYNOPSIS

  my $subject = $headers->get('subject');
  print $subject->value();

=head1 DESCRIPTION

This class represents a single header, which consists of a name and value.

=head1 API

This class supports the following methods:

=head1 Courriel::Header->new( ... )

This method requires two attributes, C<name> and C<value>. Both must be
strings. The C<name> cannot be empty, but the C<value> can.

=head2 $header->name()

The header name as passed to the constructor.

=head2 $header->value()

The header value as passed to the constructor.

=head2 $header->as_header_string()

Returns the header name and value with any necessary MIME encoding and folding.

=head1 AUTHOR

Dave Rolsky <autarch@urth.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by Dave Rolsky.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut


__END__

