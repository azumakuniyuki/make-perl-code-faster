#!/usr/bin/env perl
# check the first character is 4 or 5
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $Code = '5.1.1';

my $re = qr/^(.)/;
my $reNum = qr/^(\d)/;
my @int1=(1..10);
my @int2=reverse(@int1);

sub regexp { if($Code =~ /^(.)/){ return $1;} }
sub regexp_num { if($Code =~ /^(\d)/){ return $1;} }
sub regexp_compiled { if($Code =~ $re){return $1;} }
sub regexp_comp_num { if($Code =~ $reNum){return $1;} }
sub subst1 { return substr($Code, 0, 1); }
sub index1 { 
  for my $i(@int1){
    if( index($Code, "$i") == 0){
      return $i;
    }
  }
}
sub index2 { 
  for my $i(@int2){
    if( index($Code, "$i") == 0){
      return $i;
    }
  }
}

my $first = substr($Code, 0, 1);
is regexp, $first, "regexp";
is regexp_num, $first, "regexp_num";
is regexp_compiled, $first, "regexp_compiled";
is regexp_comp_num, $first, "regexp_comp_num";
is index1, $first, "index1";
is index2, $first, "index2";
is subst1, $first, "substr";

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e6, {
        '=~ /^(.)/  ' => sub { regexp() },
        '=~ /^(\d)/ ' => sub { regexp_num() },
        '=~ $re     ' => sub { regexp_compiled() },
        '=~ $reNum  ' => sub { regexp_comp_num() },
        'index1()   ' => sub { index1() },
        'index2()   ' => sub { index2() },
        'substr(..,)' => sub { subst1() },
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
