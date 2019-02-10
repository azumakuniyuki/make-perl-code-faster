#!/usr/bin/env perl
# s/// vs. substr
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $Email0 = '<neko@nyaan.jp>';
my $Email1 = 'neko@nyaan.jp';

sub regexp2 {
    my $v = shift;
    $v =~ s/\A<//;
    $v =~ s/>\z//;
    return $v;
}

sub substr4 {
    my $v = shift;
    substr($v,  0, 1, '') if substr($v,  0, 1) eq '<';
    substr($v, -1, 1, '') if substr($v, -1, 1) eq '>';
    return $v;
}

is regexp2($Email0), $Email1;
is substr4($Email0), $Email1;

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e6, {
        's/<//g' => sub { regexp2($Email0) },
        'substr' => sub { substr4($Email0) },
    }
);

__END__

Running with Perl v5.22.1 on darwin
--------------------------------------------------------------------------------
            Rate s/<//g substr
s/<//g  806452/s     --   -57%
substr 1857585/s   130%     --

Running with Perl v5.28.1 on darwin
--------------------------------------------------------------------------------
            Rate s/<//g substr
s/<//g  661521/s     --   -70%
substr 2197802/s   232%     --

