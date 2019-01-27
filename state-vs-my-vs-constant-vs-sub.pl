#!/usr/bin/env perl
# state vs. my vs. constant vs. sub {...}
use feature ':5.10';
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $NEKO1           = 'nyaan';
state $NEKO2        = 'nyaan';
use constant NEKO3 => 'nyaan';
sub NEKO4           { 'nyaan' }

sub myvariable  { my $v = shift; return $v.'-'.$NEKO1.'-'.$NEKO1 }
sub usestate    { my $v = shift; return $v.'-'.$NEKO2.'-'.$NEKO2 }
sub useconstant { my $v = shift; return $v.'-'.NEKO3.'-'.NEKO3 }
sub subroutine  { my $v = shift; return $v.'-'.NEKO4.'-'.NEKO4 }

is myvariable('neko'), 'neko-nyaan-nyaan';
is usestate('neko'),   'neko-nyaan-nyaan';
is useconstant('neko'),'neko-nyaan-nyaan';
is subroutine('neko'), 'neko-nyaan-nyaan';

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e6, {
        'my $v'      => sub { myvariable('neko') },
        'state $v'   => sub { usestate('neko') },
        'constant v' => sub { useconstant('neko') },
        'sub {...}'  => sub { subroutine('neko') },
    }
);

__END__

Running with Perl v5.22.1 on darwin
--------------------------------------------------------------------------------
                Rate  sub {...}      my $v   state $v constant v
sub {...}  1273885/s         --       -49%       -50%       -51%
my $v      2510460/s        97%         --        -2%        -3%
state $v   2553191/s       100%         2%         --        -1%
constant v 2575107/s       102%         3%         1%         --

Running with Perl v5.28.1 on darwin
--------------------------------------------------------------------------------
                Rate  sub {...}      my $v constant v   state $v
sub {...}  1812689/s         --       -54%       -56%       -56%
my $v      3973510/s       119%         --        -3%        -4%
constant v 4081633/s       125%         3%         --        -1%
state $v   4137931/s       128%         4%         1%         --

