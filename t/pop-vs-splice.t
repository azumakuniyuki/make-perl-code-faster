#!/usr/bin/env perl
# grep @list vs. exists $v
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $Array = ['cat', 'neko', 'nyaan'];

sub usepop    { my @p = @$Array; return pop @p }
sub usesplice { my @p = @$Array; return splice(@p, -1) }

is usepop(), 'nyaan';
is usesplice(), 'nyaan';

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e6, {
        'pop @v'     => sub { usepop() },
        'splice(@v)' => sub { usesplice() },
    }
);

__END__

Running with Perl v5.22.1 on darwin
--------------------------------------------------------------------------------
                Rate splice(@v)     pop @v
splice(@v) 1554404/s         --        -6%
pop @v     1657459/s         7%         --

Running with Perl v5.28.1 on darwin
--------------------------------------------------------------------------------
                Rate splice(@v)     pop @v
splice(@v) 2197802/s         --        -3%
pop @v     2272727/s         3%         --
