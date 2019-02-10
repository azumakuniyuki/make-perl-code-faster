#!/usr/bin/env perl
# for vs. foreach vs. while vs. grep
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my @List1 = ( 1 .. (1<<10) );
my @List2 = ( 1 .. (1<<10) );
my @List3 = ( 1 .. (1<<10) );
my @List4 = ( 1 .. (1<<10) );

sub loop1f {
    my $v = 0;
    for( my $e = 0; $e < 1024; $e++ ) {
        $v++ if $List1[$e] % 2 == 0;
    }
    return $v;
}

sub loop2e {
    my $v = 0;
    for my $e ( @List2 ) {
        $v++ if $e % 2 == 0;
    }
    return $v;
}

sub loop3w {
    my $v = 0;
    while( my $e = shift @List3 ) {
        $v++ if $e % 2 == 0;
    }
    return $v;
}

sub loop4g {
    my $v = 0;
    $v = grep { $_ % 2 == 0 } @List4;
    return $v;
}

is loop1f(), 512;
is loop2e(), 512;
is loop3w(), 512;
is loop4g(), 512;

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(9e4, {
        'for(my ...)' => sub { loop1f() },
        'foreach my ' => sub { loop2e() },
        'while(my ..' => sub { loop3w() },
        'grep { .. }' => sub { loop4g() },
    }
);

__END__

Running with Perl v5.22.1 on darwin
--------------------------------------------------------------------------------
            (warning: too few iterations for a reliable count)
                 Rate for(my ...) foreach my  grep { .. } while(my ..
for(my ...)    8708/s          --        -14%        -34%       -100%
foreach my    10152/s         17%          --        -23%       -100%
grep { .. }   13187/s         51%         30%          --       -100%
while(my .. 3000000/s      34350%      29450%      22650%          --

Running with Perl v5.28.1 on darwin
--------------------------------------------------------------------------------
            (warning: too few iterations for a reliable count)
                 Rate for(my ...) foreach my  grep { .. } while(my ..
for(my ...)    9202/s          --        -24%        -32%       -100%
foreach my    12146/s         32%          --        -11%       -100%
grep { .. }   13595/s         48%         12%          --       -100%
while(my .. 4500000/s      48800%      36950%      33000%          --

