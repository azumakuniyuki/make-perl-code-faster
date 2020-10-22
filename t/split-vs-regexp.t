#!/usr/bin/env perl
# grep @list vs. exists $v
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $Subject = 'Subject: Neko::Nyaan(Kijitora)';

sub usesplit {
    my $v = shift;
    my($l, $r) = split(/:[ ]*/, $v, 2);
    return { 'header' => $l, 'value' => $r };
}

sub useregex {
    my $v = shift;
    if( $v =~ /\A(.+?):[ ]*(.+)\z/ ) {
        return { 'header' => $1, 'value' => $2 };
    }
}

isa_ok usesplit($Subject), 'HASH';
isa_ok useregex($Subject), 'HASH';

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e6, {
        'split(":")' => sub { usesplit($Subject) },
        '$v =~ /../' => sub { useregex($Subject) },
    }
);

__END__

Running with Perl v5.22.1 on darwin
--------------------------------------------------------------------------------
               Rate split(":") $v =~ /../
split(":") 498339/s         --       -12%
$v =~ /../ 566572/s        14%         --

Running with Perl v5.28.1 on darwin
--------------------------------------------------------------------------------
               Rate split(":") $v =~ /../
split(":") 420463/s         --       -14%
$v =~ /../ 489396/s        16%         --

