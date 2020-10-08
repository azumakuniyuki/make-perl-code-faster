#!/usr/bin/env perl
# check the first character is 4 or 5
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $Code = '5.1.1';
my $Re1c = qr/\A[45]/;

sub regexp { return 1 if $Code =~ /\A[45]/ }
sub callqr { return 1 if $Code =~ $Re1c }
sub index1 { return 1 if( index($Code, '4') == 0 || index($Code, '5') == 0 ) }
sub subst1 { return 1 if( substr($Code, 0, 1) == 5 || substr($Code, 0, 1) == 4) }

is regexp, 1;
is callqr, 1;
is index1, 1;
is subst1, 1;

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e6, {
        '=~ /\A[45]/' => sub { regexp() },
        '=~ $Re1c'    => sub { callqr() },
        'index(...,)' => sub { index1() },
        'substr(..,)' => sub { subst1() },
    }
);

__END__

Running with Perl v5.22.1 on darwin
--------------------------------------------------------------------------------
                 Rate    =~ $Re1c =~ /\A[45]/ index(...,) substr(..,)
=~ $Re1c    1336303/s          --        -63%        -67%        -67%
=~ /\A[45]/ 3614458/s        170%          --        -10%        -11%
index(...,) 4026846/s        201%         11%          --         -1%
substr(..,) 4054054/s        203%         12%          1%          --

Running with Perl v5.28.1 on darwin
--------------------------------------------------------------------------------
                 Rate    =~ $Re1c =~ /\A[45]/ index(...,) substr(..,)
=~ $Re1c    1392111/s          --        -70%        -73%        -77%
=~ /\A[45]/ 4615385/s        232%          --         -9%        -22%
index(...,) 5084746/s        265%         10%          --        -14%
substr(..,) 5940594/s        327%         29%         17%          --

