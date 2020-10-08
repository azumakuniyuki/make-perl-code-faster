#!/usr/bin/env perl
# grep @list vs. exists $v
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';
use CPAN;

sub useref { my $v = shift; return 1 if ref $v eq 'CPAN' }
sub useisa { my $v = shift; return 1 if $v->isa('CPAN') }

my $Object = CPAN->new;
is useref($Object), 1;
is useref($Object), 1;

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e6, {
        'ref $v'  => sub { useref($Object) },
        '$v->isa' => sub { useisa($Object) },
    }
);

__END__

Running with Perl v5.22.1 on darwin
--------------------------------------------------------------------------------
             Rate $v->isa  ref $v
$v->isa 2380952/s      --    -28%
ref $v  3314917/s     39%      --

Running with Perl v5.28.1 on darwin
--------------------------------------------------------------------------------
             Rate $v->isa  ref $v
$v->isa 2843602/s      --    -26%
ref $v  3846154/s     35%      --
