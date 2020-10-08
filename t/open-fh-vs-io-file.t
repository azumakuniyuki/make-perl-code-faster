#!/usr/bin/env perl
# $v && $v eq vs. ($v // '') eq
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';
use IO::File;

sub openfh {
    my $v = [];
    open FH, __FILE__;
    push @$v, $_ while <FH>;
    close FH;
    return $v;
}

sub iofile {
    my $p = IO::File->new(__FILE__);
    my $v = [];

    push @$v, $_ while <$p>;
    $p->close;
    return scalar @$v;
}

ok openfh() > 30;
ok iofile() > 30;

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e4, {
        'open FH, ...' => sub { openfh() },
        'IO::File->new' => sub { iofile() },
    }
);

__END__

Running with Perl v5.22.1 on darwin
--------------------------------------------------------------------------------
                 Rate IO::File->new  open FH, ...
IO::File->new 17291/s            --          -22%
open FH, ...  22059/s           28%            --

Running with Perl v5.28.1 on darwin
--------------------------------------------------------------------------------
                 Rate IO::File->new  open FH, ...
IO::File->new 19231/s            --          -22%
open FH, ...  24691/s           28%            --

