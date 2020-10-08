#!/usr/bin/env perl
# (?:a|b) vs. $v eq 'a' || $v eq 'b'
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $Text = 'nyaan';

sub group { return 1 if $Text =~ /\A(?:cat|neko|nyaan)\z/ }
sub useeq { return 1 if( $Text eq 'cat' || $Text eq 'neko' || $Text eq 'nyaan' ) }

is group, 1;
is useeq, 1;

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e6, {
        '=~ /(?:a|b)/' => sub { group() },
        'eq a || eq b' => sub { useeq() },
    }
);

__END__

Running with Perl v5.22.1 on darwin
--------------------------------------------------------------------------------
                  Rate =~ /(?:a|b)/ eq a || eq b
=~ /(?:a|b)/ 2790698/s           --         -39%
eq a || eq b 4545455/s          63%           --

Running with Perl v5.28.1 on darwin
--------------------------------------------------------------------------------
                  Rate =~ /(?:a|b)/ eq a || eq b
=~ /(?:a|b)/ 3370787/s           --         -46%
eq a || eq b 6185567/s          84%           --

