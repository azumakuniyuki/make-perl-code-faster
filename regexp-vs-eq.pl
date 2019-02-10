#!/usr/bin/env perl
# /\Aneko\z/ vs. eq
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $Text = 'neko-nyaan';

sub regexp { return 1 if $Text =~ /\Aneko-nyaan\z/ }
sub eqoperator { return 1 if $Text eq 'neko-nyaan' }

is regexp, 1;
is eqoperator, 1;

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e6, {
        '=~ /\Aneko\z/' => sub { regexp() },
        'eq neko' => sub { eqoperator() },
    }
);

__END__

Running with Perl v5.22.1 on darwin
--------------------------------------------------------------------------------
                   Rate =~ /\Aneko\z/       eq neko
=~ /\Aneko\z/ 3157895/s            --          -51%
eq neko       6382979/s          102%            --

Running with Perl v5.28.1 on darwin
--------------------------------------------------------------------------------
                   Rate =~ /\Aneko\z/       eq neko
=~ /\Aneko\z/ 3550296/s            --          -64%
eq neko       9836066/s          177%            --

