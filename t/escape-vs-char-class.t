#!/usr/bin/env perl
# \. vs. [.]
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $Email = 'kijitora@soto.neko.nyaan.jp';

sub backslash { return 1 if $Email =~ /soto\.neko\.nyaan\.jp/ };
sub charclass { return 1 if $Email =~ /soto[.]neko[.]nyaan[.]jp/ };

is backslash, 1;
is charclass, 1;

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e6, {
        '\.'  => sub { backslash() },
        '[.]' => sub { charclass() },
    }
);

__END__

Running with Perl v5.22.1 on darwin
--------------------------------------------------------------------------------
         Rate   \.  [.]
\.  3508772/s   -- -11%
[.] 3921569/s  12%   --

Running with Perl v5.28.1 on darwin
--------------------------------------------------------------------------------
         Rate  \. [.]
\.  4958678/s  -- -7%
[.] 5309735/s  7%  --

