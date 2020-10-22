#!/usr/bin/env perl
# /A/i vs. lc($v) eq
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $Text1 = 'Neko-Nyaan';
my $Text2 = 'NEKO-NYAAN';

sub regexp {
    my $v = 0;
    $v++ if $Text1 =~ /neko-nyaan/i;
    $v++ if $Text2 =~ /neko-nyaan/i;
    return $v;
}

sub lcfunc {
    my $v = 0;
    $v++ if lc $Text1 eq 'neko-nyaan';
    $v++ if lc $Text2 eq 'neko-nyaan';
    return $v;
}

is regexp, 2;
is lcfunc, 2;

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e6, {
        '=~ /neko/i' => sub { regexp() },
        'lc $v eq neko' => sub { lcfunc() },
    }
);

__END__

Running with Perl v5.22.1 on darwin
--------------------------------------------------------------------------------
                   Rate    =~ /neko/i lc $v eq neko
=~ /neko/i    1574803/s            --          -39%
lc $v eq neko 2586207/s           64%            --


