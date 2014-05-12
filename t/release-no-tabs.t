
BEGIN {
  unless ($ENV{RELEASE_TESTING}) {
    require Test::More;
    Test::More::plan(skip_all => 'these tests are for release candidate testing');
  }
}

use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::NoTabsTests 0.06

use Test::More 0.88;
use Test::NoTabs;

my @files = (
    'lib/Courriel.pm',
    'lib/Courriel/Builder.pm',
    'lib/Courriel/Header.pm',
    'lib/Courriel/Header/ContentType.pm',
    'lib/Courriel/Header/Disposition.pm',
    'lib/Courriel/HeaderAttribute.pm',
    'lib/Courriel/Headers.pm',
    'lib/Courriel/Helpers.pm',
    'lib/Courriel/Part/Multipart.pm',
    'lib/Courriel/Part/Single.pm',
    'lib/Courriel/Role/HeaderWithAttributes.pm',
    'lib/Courriel/Role/Part.pm',
    'lib/Courriel/Role/Streams.pm',
    'lib/Courriel/Types.pm',
    'lib/Courriel/Types/Internal.pm',
    'lib/Email/Abstract/Courriel.pm'
);

notabs_ok($_) foreach @files;
done_testing;
