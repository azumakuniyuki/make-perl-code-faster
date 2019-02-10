#!/usr/bin/env perl
# $v && $v eq vs. ($v // '') eq
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $Text = undef;

sub andandeq  { return 1 if( $Text && $Text eq 'neko' ) }
sub definedor { return 1 if ($Text // '') eq 'neko' }

is andandeq(), undef;
is definedor(), undef;

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e6, {
        '$v && $v eq' => sub { andandeq() },
        '($v // "") eq' => sub { definedor() },
    }
);

__END__

Running with Perl v5.22.1 on darwin
--------------------------------------------------------------------------------
                        Rate convert(TAB=>SPACE)         not convert
convert(TAB=>SPACE) 229008/s                  --                -23%
not convert         295567/s                 29%                  --

Running with Perl v5.28.1 on darwin
--------------------------------------------------------------------------------
                        Rate convert(TAB=>SPACE)         not convert
convert(TAB=>SPACE) 245902/s                  --                -24%
not convert         322581/s                 31%                  --


