#!/usr/bin/env perl
# Fastest way to convert an array to a hash
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';
use List::MoreUtils qw/zip/;

my @header = (1 .. 100);
my @value  = (101..200);

my %referenceHash;
@referenceHash{@header} = @value;

sub shorthandArray{
  my($header, $value) = @_;
  my %hash;
  @hash{@$header} = @$value;
  return \%hash;
}

sub forloop{
  my($header, $value) = @_;
  my %hash;
  my $numValues = scalar(@$header);
  for(my $i=0;$i<$numValues;$i++){
    $hash{$$header[$i]} = $$value[$i];
  }
  return \%hash;
}

# https://stackoverflow.com/a/71895
sub zipPerverse { 
  my $p = @_ / 2; 
  return @_[ map { $_, $_ + $p } 0 .. $p - 1 ];
}

is_deeply(\%referenceHash, shorthandArray(\@header, \@value), "shorthand-array");
is_deeply(\%referenceHash, forloop(\@header, \@value), "for-loop");
is_deeply(\%referenceHash, {zipPerverse(@header, @value)}, "zip-perverse");
is_deeply(\%referenceHash, {zip(@header,@value)}, "List::MoreUtils");

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e4, {
        'for-loop      ' => sub{forloop(\@header,\@value)},
        'shorthandArray' => sub{shorthandArray(\@header,\@value)},
        'zip-perverse  ' => sub{zipPerverse(@header,@value)},
        'L::MoreUtils  ' => sub{zip(@header,@value)},
    }
);

__END__

Running with Perl v5.22.1 on darwin
--------------------------------------------------------------------------------
                 Rate =~ /\A[45]/ substr(..,) index(...,)
=~ /\A[45]/ 3592814/s          --         -5%         -7%
substr(..,) 3797468/s          6%          --         -2%
index(...,) 3870968/s          8%          2%          --

Running with Perl v5.28.1 on darwin
--------------------------------------------------------------------------------
                 Rate =~ /\A[45]/ index(...,) substr(..,)
=~ /\A[45]/ 4545455/s          --        -17%        -18%
index(...,) 5454545/s         20%          --         -2%
substr(..,) 5555556/s         22%          2%          --
