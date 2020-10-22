#!/usr/bin/env perl
# sprintf vs. $a.$b
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $Text1 = 'Neko';
my $Text2 = 'Nyaan';
my $Text3 = 'Cat';

sub dot { return $Text1.'-'.$Text2.'-'.$Text3 }
sub spr { return sprintf("%s-%s-%s", $Text1, $Text2, $Text3) }

is dot, 'Neko-Nyaan-Cat';
is spr, 'Neko-Nyaan-Cat';

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e6, {
        '$a.$b.$c' => sub { dot() },
        'sprintf'  => sub { spr() },
    }
);

__END__

Running with Perl v5.22.1 on darwin
--------------------------------------------------------------------------------
              Rate  sprintf $a.$b.$c
sprintf  2489627/s       --     -32%
$a.$b.$c 3636364/s      46%       --

Running with Perl v5.28.1 on darwin
--------------------------------------------------------------------------------
              Rate  sprintf $a.$b.$c
sprintf  7228916/s       --      -2%
$a.$b.$c 7407407/s       2%       --

