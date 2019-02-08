#!/usr/bin/env perl
# << vs. *, /
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

sub bs { my $v = shift; $v = $v << 1; return $v }
sub mp { my $v = shift; $v *= 2; return $v }

is bs(22), 44;
is mp(22), 44;

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e6, {
        'bitshift' => sub { bs(2) },
        'multiply' => sub { mp(2) },
    }
);

__END__

Running with Perl v5.22.1 on darwin
--------------------------------------------------------------------------------
              Rate bitshift multiply
bitshift 4195804/s       --      -6%
multiply 4477612/s       7%       --

Running with Perl v5.28.1 on darwin
--------------------------------------------------------------------------------
              Rate multiply bitshift
multiply 6060606/s       --      -4%
bitshift 6315789/s       4%       --

