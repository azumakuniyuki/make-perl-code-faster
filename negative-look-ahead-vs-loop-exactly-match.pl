#!/usr/bin/env perl
# Loop and exactly match vs. Negative look ahead
use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';
use Data::Dumper;

my $Required = qr/(Final-Recipient|Action|Status|Remote-MTA|Diagnostic-Code)/;
my $Headers1 = '
Final-Recipient: RFC822; kijitora@rokujo.example.jp
Action: failed
Status: 5.6.0
Remote-MTA: DNS; rokujo.example.jp
Diagnostic-Code: SMTP; 552 5.6.0 Headers too large (3 max)
Last-Attempt-Date: Thu, 6 Jul 2017 20:27:19 +0900
';

my $Headers2 = '
Final-Recipient: RFC822; neko@example.jp
Action: failed
Status: 5.1.1
Remote-MTA: DNS; mx.example.jp
Diagnostic-Code: SMTP; 550 5.1.1 The user does not exist in
    virtual mailbox list of our server
Last-Attempt-Date: Thu, 6 Jul 2017 20:27:19 +0900
';

sub em {
    my $v = {};
    my $h = ''; # Keep the last header name for "Diagnostic-Code" field

    for my $ee ( split(/\n/, $Headers2) ) {
        if( $ee =~ /\A$Required:\s*(.+)\z/ ) {
            $v->{ $1 } = $2;
            $h = $1;

        } elsif( $ee =~ /\A\s+(.+)\z/ ) {
            $v->{ $h } .= ' '.$1;
        }
    }
    return $v;
}

sub la {
    my $v = {};

    %$v = $Headers2 =~ m{
        ^           # 冒頭か改行の直後という意味での行頭から
        $Required   # ヘッダ名があり
        : \s*       # コロンと空白0文字以上で区切られて
        (.*?)       # 値は改行を越えて続くかもしれない
        \n (?!\s)   # 終端は、その直後が空白類文字でない改行
    }gmsx;
    y/\n / /s for values %$v;
    return $v;
}

my $re = em();
my $rl = la();
print Data::Dumper::Dumper $re;
print Data::Dumper::Dumper $rl;

for my $e ( $re, $rl ) {
    is $e->{'Diagnostic-Code'}, 'SMTP; 550 5.1.1 The user does not exist in virtual mailbox list of our server';
    is $e->{'Action'}, 'failed';
    is $e->{'Remote-MTA'}, 'DNS; mx.example.jp';
    is $e->{'Final-Recipient'}, 'RFC822; neko@example.jp';
    is $e->{'Status'}, '5.1.1';
}

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(6e5, {
        'for $e =~ /.../' => sub { em() },
        '%e =~ /...(?!)/' => sub { la() },
    }
);

__END__
$VAR1 = {
          'Remote-MTA' => 'DNS; mx.example.jp',
          'Status' => '5.1.1',
          'Final-Recipient' => 'RFC822; neko@example.jp',
          'Diagnostic-Code' => 'SMTP; 550 5.1.1 The user does not exist in virtual mailbox list of our server',
          'Action' => 'failed'
        };
$VAR1 = {
          'Remote-MTA' => 'DNS; mx.example.jp',
          'Diagnostic-Code' => 'SMTP; 550 5.1.1 The user does not exist in virtual mailbox list of our server',
          'Final-Recipient' => 'RFC822; neko@example.jp',
          'Action' => 'failed',
          'Status' => '5.1.1'
        };
ok 1
ok 2
ok 3
ok 4
ok 5
ok 6
ok 7
ok 8
ok 9
ok 10
Running with Perl v5.30.0 on darwin
--------------------------------------------------------------------------------
                    Rate for $e =~ /.../ %e =~ /...(?!)/
for $e =~ /.../  62305/s              --            -56%
%e =~ /...(?!)/ 140187/s            125%              --
1..10
