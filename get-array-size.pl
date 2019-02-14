#!/usr/bin/env perl
# scalar @v vs. $#v - 1
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my @Array = (1..(1<<10));

sub usescalar { return scalar @Array }
sub lastindex { return $#Array + 1 }

is usescalar, 1024;
is lastindex, 1024;

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e6, {
        'scalar' => sub { usescalar() },
        '$#v +1' => sub { lastindex() },
    }
);

__END__

Running with Perl v5.18.2 on darwin
--------------------------------------------------------------------------------
            Rate $#v +1 scalar
$#v +1 4444444/s     --   -21%
scalar 5607477/s    26%     --

Running with Perl v5.22.1 on darwin
--------------------------------------------------------------------------------
            Rate $#v +1 scalar
$#v +1 4195804/s     --   -29%
scalar 5940594/s    42%     --

Running with Perl v5.28.1 on darwin
--------------------------------------------------------------------------------
            Rate $#v +1 scalar
$#v +1 8219178/s     --    -3%
scalar 8450704/s     3%     --

