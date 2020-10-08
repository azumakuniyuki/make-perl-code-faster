#!/usr/bin/env perl
# $a = $b; $b =~ s/.../.../ vs. $b = $a =~ s/.../.../r
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $Text = 'Neko-Nyaan';

sub rmod {
    my $p = $Text =~ s/Nyaan/Nya-n/r;
    return $p;
}

sub copy {
    my $p = $Text;
    $p =~ s/Nyaan/Nya-n/;
    return $p;
}

is rmod(), 'Neko-Nya-n';
is copy(), 'Neko-Nya-n';
is $Text,  'Neko-Nyaan';

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e6, {
        's/.../.../r' => sub { rmod() },
        's/.../.../'  => sub { copy() },
    }
);

__END__
Running with Perl v5.30.0 on darwin
--------------------------------------------------------------------------------
                 Rate  s/.../.../ s/.../.../r
s/.../.../  2352941/s          --        -11%
s/.../.../r 2654867/s         13%          --

