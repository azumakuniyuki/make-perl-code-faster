#!/usr/bin/env perl
# for vs. foreach vs. while vs. grep
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

sub loop1f {
    my $v = 0;
    my @p = (1..(1<<6));
    for( my $e = 0; $e < scalar(@p); $e++ ) {
        $v++ if $p[$e] % 2 == 0;
    }
    return $v;
}

sub loop2e2 {
    my $v = 0;
    my @p = (1..(1<<6));
    foreach my $e ( @p ) {
        $v++ if $e % 2 == 0;
    }
    return $v;
}

sub loop2e {
    my $v = 0;
    my @p = (1..(1<<6));
    for my $e ( @p ) {
        $v++ if $e % 2 == 0;
    }
    return $v;
}

sub loop3w {
    my $v = 0;
    my @p = (1..(1<<6));
    while( my $e = shift @p ) {
        $v++ if $e % 2 == 0;
    }
    return $v;
}

sub loop4g {
    my $v = 0;
    my @p = (1..(1<<6));
    $v = grep { $_ % 2 == 0 } @p;
    return $v;
}

is loop1f(), 32;
is loop2e(), 32;
is loop3w(), 32;
is loop4g(), 32;

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(9e4, {
        'for(my ...)' => sub { loop1f() },
        'for my'     => sub { loop2e() },
        'foreach my '=> sub { loop2e2() },
        'while(my ..' => sub { loop3w() },
        'grep { .. }' => sub { loop4g() },
    }
);

__END__

Running with Perl v5.18.2 on darwin
--------------------------------------------------------------------------------
                Rate for(my ...) while(my .. foreach my  grep { .. }
for(my ...)  64286/s          --         -9%        -36%        -45%
while(my ..  70866/s         10%          --        -29%        -39%
foreach my  100000/s         56%         41%          --        -14%
grep { .. } 116883/s         82%         65%         17%          --

Running with Perl v5.22.1 on darwin
--------------------------------------------------------------------------------
                Rate for(my ...) while(my .. foreach my  grep { .. }
for(my ...)  73171/s          --        -10%        -41%        -46%
while(my ..  81081/s         11%          --        -34%        -41%
foreach my  123288/s         68%         52%          --        -10%
grep { .. } 136364/s         86%         68%         11%          --

Running with Perl v5.28.1 on darwin
--------------------------------------------------------------------------------
                Rate for(my ...) while(my .. foreach my  grep { .. }
for(my ...)  81081/s          --         -9%        -44%        -47%
while(my ..  89109/s         10%          --        -39%        -42%
foreach my  145161/s         79%         63%          --         -5%
grep { .. } 152542/s         88%         71%          5%          --

