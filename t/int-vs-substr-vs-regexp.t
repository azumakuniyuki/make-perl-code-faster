#!/usr/bin/env perl
# grep @list vs. exists $v
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $Code = 421;

sub useint    { my $v = shift; return int($v / 100) }
sub usesubstr { my $v = shift; return substr($v, 0, 1) }
sub useregexp { my $v = shift; return $1 if $v =~ /\A(.)/ }

is useint($Code), 4;
is usesubstr($Code), 4;
is useregexp($Code), 4;

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e6, {
        'int($v/100)'    => sub { useint($Code) },
        'substr($v,0,1)' => sub { usesubstr($Code) },
        '$v =~ /\A(.)/'  => sub { useregexp($Code) },
    }
);

__END__

Running with Perl v5.22.1 on darwin
--------------------------------------------------------------------------------
                    Rate  $v =~ /\A(.)/ substr($v,0,1)    int($v/100)
$v =~ /\A(.)/  1666667/s             --           -49%           -52%
substr($v,0,1) 3260870/s            96%             --            -5%
int($v/100)    3448276/s           107%             6%             --

Running with Perl v5.28.1 on darwin
--------------------------------------------------------------------------------
                    Rate  $v =~ /\A(.)/    int($v/100) substr($v,0,1)
$v =~ /\A(.)/  1875000/s             --           -54%           -55%
int($v/100)    4054054/s           116%             --            -3%
substr($v,0,1) 4166667/s           122%             3%             --

