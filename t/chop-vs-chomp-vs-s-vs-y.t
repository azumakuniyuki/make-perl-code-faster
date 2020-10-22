#!/usr/bin/env perl
# chop vs. chomp vs. s
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $Neko = "nyaan\n";

sub usechop  { my $v = shift; chop $v;  return $v }
sub usechomp { my $v = shift; chomp $v; return $v }
sub uses     { my $v = shift; $v =~ s/\n\z//; return $v }
sub usey     { my $v = shift; $v =~ y/\n//d;  return $v }

is usechop($Neko),  'nyaan';
is usechomp($Neko), 'nyaan';
is uses($Neko),     'nyaan';
is usey($Neko),     'nyaan';

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e6, {
        'chop $v'     => sub { usechop($Neko) },
        'chomp $v'    => sub { usechomp($Neko) },
        '$v =~ s///'  => sub { uses($Neko) },
        '$v =~ y///d' => sub { usey($Neko) },
    }
);

__END__

Running with Perl v5.22.1 on darwin
--------------------------------------------------------------------------------
                 Rate  $v =~ s/// $v =~ y///d    chomp $v     chop $v
$v =~ s///  1382488/s          --        -60%        -65%        -65%
$v =~ y///d 3488372/s        152%          --        -10%        -12%
chomp $v    3896104/s        182%         12%          --         -2%
chop $v     3973510/s        187%         14%          2%          --

Running with Perl v5.28.1 on darwin
--------------------------------------------------------------------------------
                 Rate  $v =~ s/// $v =~ y///d    chomp $v     chop $v
$v =~ s///  1530612/s          --        -65%        -69%        -70%
$v =~ y///d 4316547/s        182%          --        -14%        -17%
chomp $v    5000000/s        227%         16%          --         -3%
chop $v     5172414/s        238%         20%          3%          --

