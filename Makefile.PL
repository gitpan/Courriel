
use strict;
use warnings;

use 5.010000;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  'ABSTRACT' => 'High level email parsing and manipulation',
  'AUTHOR' => 'Dave Rolsky <autarch@urth.org>',
  'BUILD_REQUIRES' => {
    'Test::Differences' => '0',
    'Test::Fatal' => '0',
    'Test::More' => '0.88'
  },
  'CONFIGURE_REQUIRES' => {
    'ExtUtils::MakeMaker' => '6.30'
  },
  'DISTNAME' => 'Courriel',
  'EXE_FILES' => [],
  'LICENSE' => 'artistic_2',
  'NAME' => 'Courriel',
  'PREREQ_PM' => {
    'DateTime' => '0',
    'DateTime::Format::Mail' => '0',
    'Devel::PartialDump' => '0',
    'Email::Address' => '0',
    'Email::MIME::Encodings' => '0',
    'Email::MessageID' => '0',
    'File::LibMagic' => '0',
    'List::AllUtils' => '0',
    'MIME::Base64' => '0',
    'MIME::QuotedPrint' => '0',
    'Moose' => '0',
    'MooseX::Params::Validate' => '0',
    'MooseX::StrictConstructor' => '0',
    'MooseX::Types' => '0',
    'MooseX::Types::Common::String' => '0',
    'Sub::Exporter' => '0',
    'namespace::autoclean' => '0'
  },
  'VERSION' => '0.05',
  'test' => {
    'TESTS' => 't/*.t'
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



