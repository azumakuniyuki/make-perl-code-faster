#!/usr/bin/env perl
# $v && $v eq vs. ($v // '') eq
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $Hash = {'field' => 'final-recipient', 'type' => 'rfc822', 'value' => 'neko@nyaan.jp'};
my $List = ['final-recipient', 'rfc822', 'neko@nyaan.jp'];
my $Text = 'final-recipient: neko@nyaan.jp';

sub fromhash { return $Hash->{'field'}.': '.$Hash->{'value'} }
sub fromlist { return $List->[0].': '.$List->[2] }

is fromhash(), $Text;
is fromlist(), $Text;

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e6, {
        '$Hash->{...}' => sub { fromhash() },
        '$List->[...]' => sub { fromlist() },
    }
);

__END__

Running with Perl v5.22.1 on darwin
--------------------------------------------------------------------------------
                  Rate $Hash->{...} $List->[...]
$Hash->{...} 3296703/s           --         -14%
$List->[...] 3846154/s          17%           --

Running with Perl v5.28.1 on darwin
--------------------------------------------------------------------------------
                  Rate $Hash->{...} $List->[...]
$Hash->{...} 4761905/s           --         -27%
$List->[...] 6521739/s          37%           --

