#!/usr/bin/env perl
# $v =~ // && grep ... vs for(...)
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $String = 'Delivery failed, blacklisted by rbl.nyaan.jp';
my $RegExp = qr{(?>
     access[ ]denied[.][ ]ip[ ]name[ ]lookup[ ]failed
    |all[ ]mail[ ]servers[ ]must[ ]have[ ]a[ ]ptr[ ]record[ ]with[ ]a[ ]valid[ ]reverse[ ]dns[ ]entry
    |bad[ ]sender[ ]ip[ ]address
    |the[ ](?:email|domain|ip).+[ ]is[ ]blacklisted
    |this[ ]system[ ]will[ ]not[ ]accept[ ]messages[ ]from[ ]servers[/]devices[ ]with[ ]no[ ]reverse[ ]dns
    |too[ ]many[ ]spams[ ]from[ ]your[ ]ip  # free.fr
    |unresolvable[ ]relay[ ]host[ ]name
    |blacklisted[ ]by
    )
}x;
my $Fixed = [
    'access denied. ip name lookup failed',
    'all mail servers must have a ptr record with a valid reverse dns entry',
    'bad sender ip address',
    ' is blacklisted',
    'this system will not accept messages from servers/devices with no reverse dns',
    'too many spams from your ip',  # free.fr
    'unresolvable relay host name',
    'blacklisted by',
];

sub regex {
    my $v = shift;
    return 1 if $v =~ $RegExp;
}

sub grep1 {
    my $v = shift;
    return 1 if grep { index($v, $_) > -1 } @$Fixed;
}

sub grep2 {
    my $v = shift;
    return 1 if grep { rindex($v, $_) > -1 } @$Fixed;
}

sub loop1 {
    my $v = shift;
    my $p = 0;
    for my $e ( @$Fixed ) {
        next if index($v, $e) == -1;
        $p = 1;
        last;
    }
    return $p;
}

is regex($String), 1;
is grep1($String), 1;
is grep2($String), 1;
is loop1($String), 1;

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e5, {
        '$v =~ //' => sub { regex($String) },
        'grep { index }' => sub { grep1($String) },
        'grep { rindex }' => sub { grep2($String) },
        'for { index }' => sub { loop1($String) },
    }
);

__END__
Running with Perl v5.22.1 on darwin
--------------------------------------------------------------------------------
                    Rate   $v =~ // for { index } grep { index } grep { rindex }
$v =~ //        447761/s         --          -33%           -45%            -49%
for { index }   666667/s        49%            --           -18%            -23%
grep { index }  810811/s        81%           22%             --             -7%
grep { rindex } 869565/s        94%           30%             7%              --

Running with Perl v5.28.1 on darwin
--------------------------------------------------------------------------------
                     Rate  $v =~ // for { index } grep { index } grep { rindex }
$v =~ //         500000/s        --          -44%           -50%            -57%
for { index }    895522/s       79%            --           -10%            -22%
grep { index }  1000000/s      100%           12%             --            -13%
grep { rindex } 1153846/s      131%           29%            15%              --

