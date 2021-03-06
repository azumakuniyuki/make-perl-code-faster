#!/usr/bin/env perl
# Benchmark for sliding windows of strings

use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';
use Digest::MD5 qw/md5/;
use Digest::CRC qw/crc16 crc32 crc64/;

srand(42); # keep the test nonrandom

my $str = "";
my @ABC = ("A".."Z"); # alphabet
for(1..1000){
  $str.=$ABC[int(rand(26))];
}

my @arr = split(//, $str);

sub substrings{
  my $str = shift;
  my $k=21; # 21-mers
  my $numWindows = length($str) - $k;
  my @substr = ();
  for(my $i = 0; $i < $numWindows; $i++){
    push(@substr,
      substr($str, $i, $k)
    );
  }
  return \@substr;
}
sub arrays{
  my $str = shift;
  my $k=21; # 21-mers
  my $numWindows = length($str) - $k;
  my @arr = split(//, $str);

  my @substr = ();
  for(my $i = 0; $i < $numWindows; $i++){
    push(@substr,
      join("", @arr[$i..($i+$k-1)])
    );
  }
  return \@substr;
}
sub arraysFromArrays{
  my $arr= shift;
  my $k=21; # 21-mers
  my $numWindows = scalar(@$arr) - $k;

  my @substr = ();
  for(my $i = 0; $i < $numWindows; $i++){
    #my $str = join("", @$arr[0..$k-1]);
    #die "$str $i" if(length($str) < $k);
    push(@substr,
      join("", @$arr[$i..$i+$k-1])
    );
    #shift(@$arr);
  }
  return \@substr;
}

sub register{
  my $str = shift;
  my $k=21; # 21-mers
  my $length     = length($str);
  my $numWindows = length($str)-$k;
  my @substr = ();
  my @register = split(//, $str, $k+1);
  pop(@register); # remove chunk of unsplit string in last element
  for(my $i = $k; $i < $length; $i++){
    push(@substr,
      join("", @register)
    );

    # Shift the register
    shift(@register);
    push(@register,
      substr($str,$i,1)
    );
  }
  return \@substr;
}

sub registerWithHash{
  my $str = shift;
  my $k=21; # 21-mers
  my $numWindows = length($str)-$k;
  my @substr = ();
  my @register = split(//, $str, $k+1);
  pop(@register); # remove chunk of unsplit string in last element
  my %hashmap;
  for(my $i = 0; $i < $numWindows; $i++){
    my $substr = join("", @register);
    my $hash = crc16($substr);
    push(@substr,$hash);
    $hashmap{$hash} = $substr;

    # Shift the register
    shift(@register);
    push(@register, substr($str,$i+$k,1));
  }
  for(@substr){
    $_=$hashmap{$_};
  }
  #for(my $i=0;$i<$numWindows;$i++){
  #  $register[$i] = $hashmap{$register[$i]};
  #}
  return \@substr;
}

my $firstKmer = "TICKCWMMRVMPNAUPXMNML";
my $lastKmer  = "GXQTCEJMLHYASCEKVHJEA";
my $thirdKmer = "CKCWMMRVMPNAUPXMNMLJX";
my $kmers1 = substrings($str);
my $kmers2 = arrays($str);
my $kmers3 = arraysFromArrays(\@arr);
my $kmers4 = register($str);
my $kmers5 = registerWithHash($str);
is( $$kmers1[0], $firstKmer, "substrings first kmer");
is( $$kmers1[2], $thirdKmer, "substrings third kmer");
is( $$kmers1[-1],$lastKmer,  "substrings last kmer");
is( scalar(@$kmers1), 1000 - 21, "number of kmers");

is( $$kmers2[0], $firstKmer, "arrays first kmer");
is( $$kmers2[2], $thirdKmer, "arrays third kmer");
is( $$kmers2[-1],$lastKmer,  "arrays last kmer");
is( scalar(@$kmers2), 1000 - 21, "number of kmers");

is( $$kmers3[0], $firstKmer, "arrays first kmer");
is( $$kmers3[2], $thirdKmer, "arrays third kmer");
is( $$kmers3[-1],$lastKmer,  "arrays last kmer");
is( scalar(@$kmers3), 1000 - 21, "number of kmers");

is( $$kmers4[0], $firstKmer, "registers first kmer");
is( $$kmers4[2], $thirdKmer, "registers third kmer");
is( $$kmers4[-1],$lastKmer,  "registers arrays last kmer");
is( scalar(@$kmers4), 1000 - 21, "number of kmers");

is( $$kmers5[0], $firstKmer, "registers first kmer");
is( $$kmers5[2], $thirdKmer, "registers third kmer");
is( $$kmers5[-1],$lastKmer,  "registers arrays last kmer");
is( scalar(@$kmers5), 1000 - 21, "number of kmers");

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e3, {
        'Substring'          => sub { substrings($str) },
        'SubstringToArray'   => sub { arrays($str) },
        'Array to array'     => sub { arraysFromArrays(\@arr) },
        'Registers'          => sub { register($str) },
        'RegistersWithHash'  => sub { registerWithHash($str) },
    }
);

__END__

Running with Perl v5.18.2 on darwin
--------------------------------------------------------------------------------
                    Rate RegistersWithHash SubstringToArray Array to array Registers Substring
RegistersWithHash 1.81/s                --            -100%          -100%     -100%     -100%
SubstringToArray   381/s            21021%               --           -27%      -58%      -84%
Array to array     526/s            29018%              38%             --      -41%      -78%
Registers          898/s            49636%             135%            71%        --      -62%
Substring         2344/s           129679%             514%           346%      161%        --
1..20

