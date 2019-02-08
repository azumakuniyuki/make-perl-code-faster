#!/usr/bin/env perl
# s/// vs. y///
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $Version = 'Perl 5.28.1';
my $Address = '<neko@nyaan.jp>';
my $Package = 'Neko::Nyaan::Cat';

sub ss {
    my($a, $b, $c) = @_;
    $a =~ s/\D//g;
    $b =~ s/[<>]//g;
    $c =~ s|::|/|g; $c .= '.pm';
    return sprintf("%s-%s-%s", $a, $b, $c);
}

sub yy {
    my($a, $b, $c) = @_;
    $a =~ y/0-9//cd;
    $b =~ y/<>//d;
    $c =~ y|:|/|; $c =~ y|/||s; $c .= '.pm';
    return sprintf("%s-%s-%s", $a, $b, $c);
}

is ss($Version, $Address, $Package), '5281-neko@nyaan.jp-Neko/Nyaan/Cat.pm';
is yy($Version, $Address, $Package), '5281-neko@nyaan.jp-Neko/Nyaan/Cat.pm';

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e6, {
        's///' => sub { ss($Version, $Address, $Package) },
        'y///' => sub { yy($Version, $Address, $Package) },
    }
);

__END__

Running with Perl v5.22.1 on darwin
--------------------------------------------------------------------------------
         Rate s/// y///
s/// 188739/s   -- -80%
y/// 928793/s 392%   --

Running with Perl v5.28.1 on darwin
--------------------------------------------------------------------------------
          Rate s/// y///
s///  223881/s   -- -84%
y/// 1369863/s 512%   --

