use strict;
use warnings;
 
use 5.010;
 
use ExtUtils::MakeMaker;

# $ grep -h -o 'use  *[^ ]*' t/*.pl | sort | uniq
# use Benchmark
# use constant
# use CPAN;
# use Data::Dumper;
# use DBD::CSV;
# use DBD::SQLite;
# use DBM::Deep;
# use Digest::CRC
# use Digest::MD5
# use feature
# use IO::File;
# use List::MoreUtils
# use List::Util
# use strict;
# use Test::More
# use warnings;

WriteMakefile(
  NAME         => 'make-perl-faster',
  VERSION      => '0.1',
  AUTHOR => q{azuma, kuniyuki},
  EXE_FILES    => [
  ],
  PREREQ_PM    => {
    # Core modules
    CPAN             => 0,
    Benchmark        => 0,
    'Data::Dumper'   => 0,
    'DBD::CSV'       => 0,
    'DBD::SQLite'    => 0,
    'DBM::Deep'      => 0,
    'Digest::CRC'    => 0,
    'Digest::MD5'    => 0,
    'IO::File'       => 0,
    'List::MoreUtils'=> 0,
    'List::Util'     => 0,
  },
  BUILD_REQUIRES => {
    'Test::More'     => 0.47,
  },
  MIN_PERL_VERSION => '5.10.0',
  LICENSE          => "gpl_3",
  dist=>{
    COMPRESS => "gzip -9f",
    SUFFIX   => "gz",
  },
  META_MERGE => {
    'meta-spec' => { version => 2 },
    resources => {
      repository => {
        type => 'git',
        url => 'https://github.com/azumakuniyuki/make-perl-code-faster.git',
        web => 'https://github.com/azumakuniyuki/make-perl-code-faster',
      },
    },
  },
);

