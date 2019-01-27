#!/usr/bin/env perl
# $v[$#v] vs. $v[-1] vs. $v[scalar @v]
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my @Array = (1 .. 1e2);

sub dollarsharp   { return ($Array[$#Array] + $Array[$#Array - 1]) }
sub negativeindex { return ($Array[-1] + $Array[-2]) }
sub callscalar    { return ($Array[scalar(@Array)-1] + $Array[scalar(@Array)-2]) }

is dollarsharp(),   199;
is negativeindex(), 199;
is callscalar(),    199;

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e6, {
        '$v[$#v]'       => sub { dollarsharp() },
        '$v[-1]'        => sub { negativeindex() },
        '$v[scalar @v]' => sub { callscalar() },
    }
);

__END__

Running with Perl v5.22.1 on darwin
--------------------------------------------------------------------------------
                   Rate $v[scalar @v]       $v[$#v]        $v[-1]
$v[scalar @v] 2764977/s            --          -20%          -55%
$v[$#v]       3468208/s           25%            --          -43%
$v[-1]        6122449/s          121%           77%            --

Running with Perl v5.28.1 on darwin
--------------------------------------------------------------------------------
                    Rate $v[scalar @v]       $v[$#v]        $v[-1]
$v[scalar @v]  3973510/s            --          -23%          -60%
$v[$#v]        5172414/s           30%            --          -48%
$v[-1]        10000000/s          152%           93%            --

