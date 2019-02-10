#!/usr/bin/env perl
# check the first character is 4 or 5
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $Code = '5.1.1';

sub regexp { return 1 if $Code =~ /\A[45]/ }
sub index1 { return 1 if( index($Code, '4') == 0 || index($Code, '5') == 0 ) }
sub subst1 { return 1 if( substr($Code, 0, 1) == 5 || substr($Code, 0, 1) == 4) }

is regexp, 1;
is index1, 1;
is subst1, 1;

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e6, {
        '=~ /\A[45]/' => sub { regexp() },
        'index(...,)' => sub { index1() },
        'substr(..,)' => sub { subst1() },
    }
);

__END__

Running with Perl v5.22.1 on darwin
--------------------------------------------------------------------------------
                 Rate =~ /\A[45]/ substr(..,) index(...,)
=~ /\A[45]/ 3592814/s          --         -5%         -7%
substr(..,) 3797468/s          6%          --         -2%
index(...,) 3870968/s          8%          2%          --

Running with Perl v5.28.1 on darwin
--------------------------------------------------------------------------------
                 Rate =~ /\A[45]/ index(...,) substr(..,)
=~ /\A[45]/ 4545455/s          --        -17%        -18%
index(...,) 5454545/s         20%          --         -2%
substr(..,) 5555556/s         22%          2%          --
