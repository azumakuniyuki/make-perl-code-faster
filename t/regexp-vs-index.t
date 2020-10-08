#!/usr/bin/env perl
# /\Aneko/ vs. index
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $Text1 = 'neko-nyaan';
my $Text2 = 'kijitora-neko';

sub regexp {
    my $v = 0;
    $v++ if $Text1 =~ /\Aneko/;
    $v++ if $Text2 =~ /\Akijitora/;
    return $v;
}

sub index1 {
    my $v = 0;
    $v++ if index($Text1, 'neko') == 0;
    $v++ if index($Text2, 'kijitora') == 0;
    return $v;
}

is regexp, 2;
is index1, 2;

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e6, {
        '=~ /\Aneko/' => sub { regexp() },
        'index(neko)' => sub { index1() },
    }
);

__END__

Running with Perl v5.22.1 on darwin
--------------------------------------------------------------------------------
                 Rate =~ /\Aneko/ index(neko)
=~ /\Aneko/ 1612903/s          --        -40%
index(neko) 2690583/s         67%          --

Running with Perl v5.28.1 on darwin
--------------------------------------------------------------------------------
                 Rate =~ /\Aneko/ index(neko)
=~ /\Aneko/ 1875000/s          --        -42%
index(neko) 3260870/s         74%          --

