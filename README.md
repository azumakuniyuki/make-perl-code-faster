Make Perl Code Faster
===============================================================================
- Born again "perl-benchmark-collection" repository
- `perl ./filename.pl`

Benchmark Files
-------------------------------------------------------------------------------
### [and-and-vs-defined-or.pl](and-and-vs-defined-or.pl)
0. **almost draw**
1. `$v && $v eq 'string'`
2. `($v // '') eq 'string'`

### [array-initialize-or-not.pl](array-initialize-or-not.pl)
0. **1 is faster**
1. `my @v;`
2. `my @v = ();`

### [bitshift-vs-multiply.pl](bitshift-vs-multiply.pl)
### [capture-vs-grouping.pl](capture-vs-grouping.pl)
### [check-first-character.pl](check-first-character.pl)
### [check-long-string.pl](check-long-string.pl)
### [chop-vs-chomp-vs-s-vs-y.pl](chop-vs-chomp-vs-s-vs-y.pl)
### [convert-tab-to-space.pl](convert-tab-to-space.pl)
### [dollar-sharp-vs-negative-index-vs-scalar.pl](dollar-sharp-vs-negative-index-vs-scalar.pl)
### [escape-vs-char-class.pl](escape-vs-char-class.pl)
### [fixed-length-data-competition.pl](fixed-length-data-competition.pl)
### [get-array-size.pl](get-array-size.pl)
### [get-first-character.pl](get-first-character.pl)
### [grep-array-vs-exists-hash.pl](grep-array-vs-exists-hash.pl)
### [grouping-vs-multiple-eq.pl](grouping-vs-multiple-eq.pl)
### [hash-key-name-competition.pl](hash-key-name-competition.pl)
### [i-modifier-vs-char-class.pl](i-modifier-vs-char-class.pl)
### [int-vs-substr-vs-regexp.pl](int-vs-substr-vs-regexp.pl)
### [is-email-address-or-not.pl](is-email-address-or-not.pl)
### [lc-vs-i-modifier.pl](lc-vs-i-modifier.pl)
### [leave-the-first-3-of-array.pl](leave-the-first-3-of-array.pl)
### [list-vs-hash.pl](list-vs-hash.pl)
### [local-database.pl](local-database.pl)
### [loop-competition.pl](loop-competition.pl)
### [negative-look-ahead-vs-loop-exactly-match.pl](negative-look-ahead-vs-loop-exactly-match.pl)
### [open-fh-vs-io-file.pl](open-fh-vs-io-file.pl)
### [pop-vs-splice.pl](pop-vs-splice.pl)
### [r-modifier-vs-copied-string.pl](r-modifier-vs-copied-string.pl)
### [ref-vs-isa.pl](ref-vs-isa.pl)
### [regexp-vs-eq.pl](regexp-vs-eq.pl)
### [regexp-vs-index.pl](regexp-vs-index.pl)
### [s-vs-substr.pl](s-vs-substr.pl)
### [s-vs-y.pl](s-vs-y.pl)
### [shift-vs-atmark-underscore-in-sub.pl](shift-vs-atmark-underscore-in-sub.pl)
### [sliding-window.pl](sliding-window.pl)
### [split-vs-regexp.pl](split-vs-regexp.pl)
### [sprintf-vs-dot.pl](sprintf-vs-dot.pl)
### [stat-filename-vs-underscore.pl](stat-filename-vs-underscore.pl)
### [state-vs-my-vs-constant-vs-sub.pl](state-vs-my-vs-constant-vs-sub.pl)
### [substr3-vs-substr4.pl](substr3-vs-substr4.pl)
### [zip-to-hash.pl](zip-to-hash.pl)

