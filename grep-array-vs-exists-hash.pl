#!/usr/bin/env perl
# grep @list vs. exists $v
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $Array = ['cat', 'neko', 'nyaan'];
my $Table = { 'cat' => 1, 'neko' => 1, 'nyaan' => 1 };

sub greplist { my $v = shift; return 1 if grep { $v eq $_ } @$Array }
sub existkey { my $v = shift; return 1 if exists $Table->{ $v } }

is greplist('nyaan'), 1;
is existkey('nyaan'), 1;

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e6, {
        'grep {...} @v' => sub { greplist('nyaan') },
        'exists $v->{}' => sub { existkey('nyaan') },
    }
);

__END__

Running with Perl v5.22.1 on darwin
--------------------------------------------------------------------------------
                   Rate grep {...} @v exists $v->{}
grep {...} @v 1739130/s            --          -46%
exists $v->{} 3208556/s           84%            --

Running with Perl v5.28.1 on darwin
--------------------------------------------------------------------------------
                   Rate grep {...} @v exists $v->{}
grep {...} @v 1954397/s            --          -48%
exists $v->{} 3773585/s           93%            --
