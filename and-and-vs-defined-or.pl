#!/usr/bin/env perl
# $v && $v eq vs. ($v // '') eq
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $Text = 'neko';

sub andandeq  { return 1 if( $Text && $Text eq 'neko' ) }
sub definedor { return 1 if ($Text // '') eq 'neko' }

is andandeq(), 1;
is definedor(), 1;

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e6, {
        '$v && $v eq' => sub { andandeq() },
        '($v // "") eq' => sub { definedor() },
    }
);

__END__

Running with Perl v5.22.1 on darwin
--------------------------------------------------------------------------------
                   Rate ($v // "") eq   $v && $v eq
($v // "") eq 5882353/s            --           -2%
$v && $v eq   6000000/s            2%            --

Running with Perl v5.28.1 on darwin
--------------------------------------------------------------------------------
                   Rate   $v && $v eq ($v // "") eq
$v && $v eq   8219178/s            --           -1%
($v // "") eq 8333333/s            1%            --

