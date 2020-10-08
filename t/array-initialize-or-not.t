#!/usr/bin/env perl
# \. vs. [.]
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

sub doinit {
    my @p = ();
    for my $e ( 1..(1<<5) ) {
        push @p, $e;
    }
    return scalar @p;
}

sub noinit {
    my @p;
    for my $e ( 1..(1<<5) ) {
        push @p, $e;
    }
    return scalar @p;
}

is doinit, 32;
is noinit, 32;

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(1e6, {
        'my @v = ()' => sub { doinit() },
        'my @v;' => sub { noinit() },
    }
);

__END__

Running with Perl v5.18.2 on darwin
--------------------------------------------------------------------------------
               Rate my @v = ()     my @v;
my @v = () 258398/s         --        -6%
my @v;     274725/s         6%         --

Running with Perl v5.22.1 on darwin
--------------------------------------------------------------------------------
               Rate my @v = ()     my @v;
my @v = () 300300/s         --        -7%
my @v;     322581/s         7%         --

Running with Perl v5.28.1 on darwin
--------------------------------------------------------------------------------
               Rate my @v = ()     my @v;
my @v = () 377358/s         --        -6%
my @v;     401606/s         6%         --

