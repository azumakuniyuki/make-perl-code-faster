#!/usr/bin/env perl
# splice() vs. $#v = 3
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

sub splicethree {
    my @p = (1..10);
    splice @p, 3;
    return \@p;
}

sub dollarsharp {
    my @p = (1..10);
    $#p = 2;
    return \@p;
}

is scalar @{ splicethree() }, 3;
is scalar @{ dollarsharp() }, 3;

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e5, {
        'splice' => sub { splicethree() },
        '$# = 2' => sub { dollarsharp() },
    }
);

__END__

Running with Perl v5.18.2 on darwin
--------------------------------------------------------------------------------
            Rate $# = 2 splice
$# = 2  681818/s     --   -36%
splice 1071429/s    57%     --

Running with Perl v5.22.1 on darwin
--------------------------------------------------------------------------------
            Rate $# = 2 splice
$# = 2  740741/s     --   -41%
splice 1250000/s    69%     --

Running with Perl v5.28.1 on darwin
--------------------------------------------------------------------------------
            Rate $# = 2 splice
$# = 2  845070/s     --   -41%
splice 1428571/s    69%     --

