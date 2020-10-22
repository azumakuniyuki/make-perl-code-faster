#!/usr/bin/env perl
# /A/i vs. /[Aa]/
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $Header1 = 'Message-ID: <neko-222222-0220-22@nyaan.jp>';
my $Header2 = 'Final-Recipient: rfc822; <neko@nyaan.jp>';
my $Header3 = 'Reporting-MTA: dns; mx22.nyaan.jp';

sub imodifier {
    my $v = 0;
    $v++ if $Header1 =~ /Message-Id: /i;
    $v++ if $Header2 =~ /Final-Recipient: rfc822;/i;
    $v++ if $Header3 =~ /Reporting-MTA: dns;/i;
    return $v;
}

sub charclass {
    my $v = 0;
    $v++ if $Header1 =~ /Message-[Ii][Dd]: /;
    $v++ if $Header2 =~ /Final-Recipient: [Rr][Ff][Cc]822;/;
    $v++ if $Header3 =~ /Reporting-MTA: [Dd][Nn][Ss];/;
    return $v;

}

is imodifier, 3;
is charclass, 3;

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e6, {
        '=~ /neko/i'   => sub { imodifier() },
        '=~ /[Nn]eko/' => sub { charclass() },
    }
);

__END__

Running with Perl v5.22.1 on darwin
--------------------------------------------------------------------------------
                  Rate =~ /[Nn]eko/   =~ /neko/i
=~ /[Nn]eko/  854701/s           --         -21%
=~ /neko/i   1083032/s          27%           --

Running with Perl v5.28.1 on darwin
--------------------------------------------------------------------------------
                  Rate =~ /[Nn]eko/   =~ /neko/i
=~ /[Nn]eko/  975610/s           --          -4%
=~ /neko/i   1011804/s           4%           --

Running with Perl v5.30.0 on darwin
--------------------------------------------------------------------------------
                  Rate =~ /[Nn]eko/   =~ /neko/i
=~ /[Nn]eko/ 1382488/s           --          -1%
=~ /neko/i   1398601/s           1%           --
