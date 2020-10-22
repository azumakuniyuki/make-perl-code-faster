#!/usr/bin/env perl
# substr(a,b,c) = d vs. substr(a,b,c,d)
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $Email = 'neko@example.jp';
my $Nyaan = 'nyaan.jp';

sub substr3 { my $v = shift; substr($v, -10, 10) = $Nyaan; return $v }
sub substr4 { my $v = shift; substr($v, -10, 10, $Nyaan); return $v }

is substr3($Email), 'neko@nyaan.jp';
is substr4($Email), 'neko@nyaan.jp';

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e6, {
        'substr(3)' => sub { substr3($Email) },
        'substr(4)' => sub { substr4($Email) },
    }
);

__END__

Running with Perl v5.22.1 on darwin
--------------------------------------------------------------------------------
               Rate substr(4) substr(3)
substr(4) 3658537/s        --       -2%
substr(3) 3750000/s        2%        --

Running with Perl v5.28.1 on darwin
--------------------------------------------------------------------------------
               Rate substr(4) substr(3)
substr(4) 4255319/s        --       -3%
substr(3) 4379562/s        3%        --

