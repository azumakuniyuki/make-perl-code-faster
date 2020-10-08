#!/usr/bin/env perl
# grep @list vs. exists $v
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

sub useshift { my $v = shift; my $e = shift; return join('-', $v, $e) }
sub atmarkus { my($v, $e) = @_; return join('-', $v, $e) }

is useshift('neko', 'nyaan'), 'neko-nyaan';
is atmarkus('neko', 'nyaan'), 'neko-nyaan';

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e6, {
        'my $v = shift' => sub { useshift('neko', 'nyaan') },
        'my $v = @_'    => sub { atmarkus('neko', 'nyaan') },
    }
);

__END__

Running with Perl v5.22.1 on darwin
--------------------------------------------------------------------------------
                   Rate my $v = shift    my $v = @_
my $v = shift 2033898/s            --          -12%
my $v = @_    2316602/s           14%            --

Running with Perl v5.28.1 on darwin
--------------------------------------------------------------------------------
                   Rate my $v = shift    my $v = @_
my $v = shift 2222222/s            --          -15%
my $v = @_    2608696/s           17%            --

