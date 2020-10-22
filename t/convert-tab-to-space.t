#!/usr/bin/env perl
# convert TAB character to space character
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';

my $Text = '
Received: from neko.example.com (neko.example.com [203.0.113.49])
	by meow.example.com (Postfix) with ESMTP id 0000002222
	for <nekonyaan@meow.example.com>; Thu, 29 Apr 2008 23:34:45 -0800 (PST)
Received: by neko.example.com (Postfix)
	id EEEEEE22222; Thu, 29 Apr 2008 23:34:45 -0800 (PST)
';
# Received: from neko.example.com (neko.example.com [203.0.113.49])
# Received: by neko.example.com (Postfix)

sub preconv {
    my $v = shift;
    my $p = '';

    $v =~ s/\t/ /g;
    for my $e ( split(/\n/, $v) ) {
        next if index($e, ' ') == 0;
        $p .= $e;
    }
    return $p;
}

sub notconv {
    my $v = shift;
    my $p = '';

    for my $e (split(/\n/, $v)) {
        next if $e =~ /\A[ \t]/;
        $p .= $e
    }
    return $p;
}

is length preconv($Text), 104;
is length notconv($Text), 104;

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e5, {
        'convert(TAB=>SPACE)' => sub { preconv($Text) },
        'not convert' => sub { notconv($Text) },
    }
);

__END__

Running with Perl v5.22.1 on darwin
--------------------------------------------------------------------------------
                        Rate convert(TAB=>SPACE)         not convert
convert(TAB=>SPACE) 229008/s                  --                -23%
not convert         295567/s                 29%                  --

Running with Perl v5.28.1 on darwin
--------------------------------------------------------------------------------
                        Rate convert(TAB=>SPACE)         not convert
convert(TAB=>SPACE) 245902/s                  --                -24%
not convert         322581/s                 31%                  --

