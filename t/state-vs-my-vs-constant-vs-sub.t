#!/usr/bin/env perl
# state vs. my vs. constant vs. sub {...}
use feature ':5.10';
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $NEKO1  = 'nyaan';
my $NYAAN1 = ['neko', 'nyaan'];
my $CAT1   = { 'v' => 2 };

state $NEKO2  = 'nyaan';
state $NYAAN2 = ['neko', 'nyaan'];
state $CAT2   = { 'v' => 2 };

use constant NEKO3  => 'nyaan';
use constant NYAAN3 => ['neko', 'nyaan'];
use constant CAT3   => { 'v' => 2 };

sub NEKO4  { 'nyaan' }
sub NYAAN4 { ['neko', 'nyaan'] };
sub CAT4   { { 'v' => 2 } };

sub myvariable  { return join('-', $NEKO1, @$NYAAN1, $CAT1->{'v'}, $NYAAN1->[1]) };
sub usestate    { return join('-', $NEKO2, @$NYAAN2, $CAT2->{'v'}, $NYAAN2->[1]) };
sub useconstant { return join('-', NEKO3, @{ NYAAN3() }, CAT3->{'v'}, NYAAN3->[1]) };
sub subroutine  { return join('-', NEKO4, @{ NYAAN4() }, CAT4->{'v'}, NYAAN4->[1]) };

is myvariable(), 'nyaan-neko-nyaan-2-nyaan';
is usestate(),   'nyaan-neko-nyaan-2-nyaan';
is useconstant(),'nyaan-neko-nyaan-2-nyaan';
is subroutine(), 'nyaan-neko-nyaan-2-nyaan';

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e6, {
        'my $v'      => sub { myvariable() },
        'state $v'   => sub { usestate() },
        'constant v' => sub { useconstant() },
        'sub {...}'  => sub { subroutine() },
    }
);

__END__

Running with Perl v5.30.0 on darwin
--------------------------------------------------------------------------------
                Rate  sub {...}      my $v constant v   state $v
sub {...}   676437/s         --       -84%       -84%       -85%
my $v      4195804/s       520%         --        -2%        -7%
constant v 4285714/s       534%         2%         --        -5%
state $v   4511278/s       567%         8%         5%         --

