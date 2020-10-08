#!/usr/bin/env perl
# $v{k} vs. $v{'k'} vs. $v{"k"}
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $Table = { 'cat' => 0, 'neko' => 1, 'nyaan' => 2, };

sub doublequote { return $Table->{"nyaan"} }
sub singlequote { return $Table->{'nyaan'} }
sub barekeyname { return $Table->{nyaan} }

is doublequote(), 2;
is singlequote(), 2;
is barekeyname(), 2;

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e6, {
        '$v["key"]'   => sub { doublequote() },
        '$v[\'key\']' => sub { singlequote() },
        '$v[key]'     => sub { barekeyname() },
    }
);

__END__

Running with Perl v5.22.1 on darwin
--------------------------------------------------------------------------------
               Rate $v["key"]   $v[key] $v['key']
$v["key"] 6451613/s        --       -2%       -3%
$v[key]   6593407/s        2%        --       -1%
$v['key'] 6666667/s        3%        1%        --

Running with Perl v5.28.1 on darwin
--------------------------------------------------------------------------------
                Rate   $v[key] $v['key'] $v["key"]
$v[key]    9230769/s        --       -3%       -9%
$v['key']  9523810/s        3%        --       -6%
$v["key"] 10169492/s       10%        7%        --

