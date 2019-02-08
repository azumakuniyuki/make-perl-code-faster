#!/usr/bin/env perl
# -f $v vs. -f _
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $File = '/etc/hosts';

sub filename   { return 1 if( -f $File && -T $File && -s $File && -r $File ) }
sub underscore { return 1 if( -f $File && -T _ && -s _ && -r _ ) }
sub stacking   { return 1 if( -f -T -s -r $File ) }

is filename, 1;
is underscore, 1;
is stacking, 1;

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e4, {
        '-f $v' => sub { filename() },
        '-f _'  => sub { underscore() },
        '-f -T' => sub { stacking() },
    }
);

__END__

Running with Perl v5.22.1 on darwin
--------------------------------------------------------------------------------
         Rate -f $v  -f _ -f -T
-f $v 28986/s    --  -20%  -20%
-f _  36145/s   25%    --   -0%
-f -T 36145/s   25%    0%    --

Running with Perl v5.28.1 on darwin
--------------------------------------------------------------------------------
         Rate -f $v  -f _ -f -T
-f $v 30612/s    --  -21%  -23%
-f _  38710/s   26%    --   -3%
-f -T 40000/s   31%    3%    --

