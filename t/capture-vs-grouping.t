#!/usr/bin/env perl
# (...) vs. (?:...)
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $Email = 'Kijitora <kijitora@nyaan.jp>';

sub captures { return 1 if $Email =~ /[.](com|net|org|edu|gov|jp|ru|uk)[>]/ }
sub grouping { return 1 if $Email =~ /[.](?:com|net|org|edu|gov|jp|ru|uk)[>]/ }

is captures, 1;
is grouping, 1;

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e6, {
        '(com|net|...)'   => sub { captures() },
        '(?:com|net|...)' => sub { grouping() },
    }
);

__END__

Running with Perl v5.22.1 on darwin
--------------------------------------------------------------------------------
                     Rate   (com|net|...) (?:com|net|...)
(com|net|...)   2158273/s              --             -4%
(?:com|net|...) 2238806/s              4%              --

Running with Perl v5.28.1 on darwin
--------------------------------------------------------------------------------
                     Rate   (com|net|...) (?:com|net|...)
(com|net|...)   2521008/s              --             -5%
(?:com|net|...) 2643172/s              5%              --

