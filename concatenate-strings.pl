#!/usr/bin/env perl
# concatenate long strings
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';
use List::Util qw/shuffle/;

my $base= join("", shuffle("A".."Z", "a".."z")); # 52 letters in random order
my $numRepeating = 1e1;
my $expected = $base x $numRepeating;

sub incrementalConcat{
  my $str="";
  for(1..$numRepeating){
    $str .= $base;
  }
  return $str;
}

sub arrayToString{
  my @arr = ($base) x $numRepeating;
  my $str = join("", @arr);
  return $str;
}

is(incrementalConcat(), $expected, "incrementalConcat");
is(arrayToString()    , $expected, "arrayToString");

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e6, {
        'incrementalConcat' => sub { incrementalConcat() },
        'arrayToString'     => sub { arrayToString() },
    }
);

