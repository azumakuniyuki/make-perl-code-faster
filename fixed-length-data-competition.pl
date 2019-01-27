#!/usr/bin/env perl
# substr() vs. regexp vs. unpack
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $SHA1 = 'e889751b9ee5f80d5704d06875d524f391604e7d';
my $Hash = 'e889751';

sub usesubstr { return substr($SHA1, 0, 7) }
sub useregexp { return $1 if $SHA1 =~ /\A(.{7})/ }
sub useunpack { return unpack('A7', $SHA1) }

is usesubstr, $Hash;
is useregexp, $Hash;
is useunpack, $Hash;

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e6, {
        'substr()' => sub { usesubstr() },
        '$v =~ //' => sub { useregexp() },
        'unpack()' => sub { useunpack() }
    }
);

__END__

Running with Perl v5.22.1 on darwin
--------------------------------------------------------------------------------
              Rate unpack() $v =~ // substr()
unpack() 2666667/s       --      -2%     -51%
$v =~ // 2714932/s       2%       --     -50%
substr() 5405405/s     103%      99%       --

Running with Perl v5.28.1 on darwin
--------------------------------------------------------------------------------
              Rate unpack() $v =~ // substr()
unpack() 2955665/s       --     -17%     -62%
$v =~ // 3550296/s      20%       --     -54%
substr() 7792208/s     164%     119%       --

