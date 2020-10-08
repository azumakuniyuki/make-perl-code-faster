#!/usr/bin/env perl
# check "<neko@nyaan.jp>" is an email address or not
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $Email = '<neko@nyaan.jp>';

sub regexp { return 1 if $Email =~ /\A[<].+[@].+[>]\z/ }
sub index1 { return 1 if( index($Email, '<') == 0 && index($Email, '@') > -1 && substr($Email, -1, 1) eq '>' ) }

is regexp, 1;
is index1, 1;

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e6, {
        '=~ /neko@.../' => sub { regexp() },
        'index, substr' => sub { index1() },
    }
);

__END__

Running with Perl v5.22.1 on darwin
--------------------------------------------------------------------------------
                   Rate =~ /neko@.../ index, substr
=~ /neko@.../ 1764706/s            --          -37%
index, substr 2803738/s           59%            --

Running with Perl v5.28.1 on darwin
--------------------------------------------------------------------------------
                   Rate =~ /neko@.../ index, substr
=~ /neko@.../ 2068966/s            --          -43%
index, substr 3636364/s           76%            --

