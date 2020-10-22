#!/usr/bin/env perl
# Benchmark for sliding windows of strings

use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';
use DBD::SQLite;
use DBD::CSV;
use Data::Dumper;
use DBM::Deep;

my $sqliteFilename    = "db.sqlite";
my $csvFilename       = "dist.csv";
my $dbmFilename  = "db.db";

# clean slate
for my $filename ($sqliteFilename, $csvFilename, $dbmFilename){
  unlink($filename);
}

my ($sqliteDbh, $csvDbh, $dbmDbh);
my %ramHash = (); # in-memory "database" - just a hash
subtest "CreateDbs" => sub{
  # Create SQLite
  $sqliteDbh = DBI->connect("dbi:SQLite:dbname=$sqliteFilename", "", "")
    or BAIL_OUT("Cannot connect DBI:SQLite: $DBI::errstr");
  my $sqliteSth = $sqliteDbh->do("CREATE TABLE DIST(
      name1 TEXT,
      name2 TEXT,
      distance INTEGER
    )
  ")
    or BAIL_OUT("ERROR creating sqlite database: $DBI::errstr");
  is(-e $sqliteFilename, 1, "$sqliteFilename exists");

  # Create CSV db
  $csvDbh = DBI->connect("dbi:CSV:", undef, undef,{
      f_ext       => ".csv/r",
      RaiseError  => 1,
    }) or BAIL_OUT("Cannot connect DBI:CSV: $DBI::errstr");
  my $csvSth = $csvDbh->do("CREATE TABLE DIST(
      name1 TEXT,
      name2 TEXT,
      distance INTEGER
    )
  ")
    or BAIL_OUT("ERROR creating csv database: $DBI::errstr");
  is(-e $csvFilename, 1, "$csvFilename exists");

  # Create DBM db
  $dbmDbh = DBM::Deep->new($dbmFilename);
  is(-e $dbmFilename, 1, "$dbmFilename exists");

  cmp_ok(scalar(keys(%ramHash)), '>', -1, "in-memory hash exists");
};


# Create insert data
my(@name1,@name2,@dist);
for my $int(1..10){
  push(@name1, "A$int");
  push(@name2, "B$int");
  push(@dist, $int);
}

sub sqlite_insert{
  my($name1, $name2, $dist)=@_;
  my $numDist = scalar(@$dist);

  my $prepareStr = "INSERT INTO DIST (name1,name2,distance)  VALUES  ";
  my @values;
  for(my $i=0;$i<$numDist;$i++){
    $prepareStr.= "(?,?,?), ";
    push(@values,$$name1[$i], $$name2[$i], $$dist[$i]);
  }
  $prepareStr=~s/,\s*$//; # remove last comma

  my $sth = $sqliteDbh->prepare($prepareStr)
    or die "ERROR: could not prepare insert statement for sqlite: $DBI::errstr";
  $sth->execute(@values)
    or die "ERROR: could not execute insert statement for sqlite: $DBI::errstr";
  
  return $numDist;
}

sub csv_insert{
  my($name1, $name2, $dist)=@_;
  my $numDist = scalar(@$dist);

  my $prepareStr = "INSERT INTO DIST (name1,name2,distance)  VALUES  ";
  my @values;
  for(my $i=0;$i<$numDist;$i++){
    $prepareStr.= "(?,?,?), ";
    push(@values,$$name1[$i], $$name2[$i], $$dist[$i]);
  }
  $prepareStr=~s/,\s*$//; # remove last comma

  my $sth = $csvDbh->prepare($prepareStr)
    or die "ERROR: could not prepare insert statement for csv: $DBI::errstr";
  $sth->execute(@values)
    or die "ERROR: could not execute insert statement for csv: $DBI::errstr";
  
  return $numDist;
}

sub dbm_insert{
  my($name1, $name2, $dist)=@_;
  my $numDist = scalar(@$dist);
  for(my $i=0;$i<$numDist;$i++){
    $$dbmDbh{$$name1[$i]}{$$name2[$i]}=$$dist[$i];
  }
  return $numDist;
}

sub ram_insert{
  my($name1, $name2, $dist)=@_;
  my $numDist = scalar(@$dist);
  for(my $i=0;$i<$numDist;$i++){
    $ramHash{$$name1[$i]}{$$name2[$i]}=$$dist[$i];
  }
  return $numDist;
}

sub sqlite_query{
  my $sth = $sqliteDbh->prepare("SELECT name1,name2,distance from DIST WHERE name1=? AND name2=?")
    or die "ERROR: could not prepare SQLite query: $DBI::errstr";
  my $res = $sth->execute("A9", "B9")
    or die "ERROR: could not execute SQLite query: $DBI::errstr";
  my $row = $sth->fetchrow_hashref()
    or die "ERROR: could not fetch SQLite query: $DBI::errstr";
  return $$row{distance};
}

sub csv_query{
  my $sth = $csvDbh->prepare("SELECT name1,name2,distance from DIST WHERE name1=? AND name2=?")
    or die "ERROR: could not prepare CSV query: $DBI::errstr";
  my $res = $sth->execute("A9", "B9")
    or die "ERROR: could not execute CSV query: $DBI::errstr";
  my $row = $sth->fetchrow_hashref()
    or die "ERROR: could not fetch CSV query: $DBI::errstr";
  return $$row{distance};
}

sub dbm_query{
  return $$dbmDbh{A9}{B9};
}

sub ram_query{
  return $ramHash{A9}{B9};
}

sub csv_update{
  CORE::state $counter = 0;
  my $mod = ($counter++ % 10)+1;
  my $sth = $csvDbh->prepare("UPDATE DIST SET distance=? WHERE name1=? AND name2=?")
    or die "ERROR: could not prepare csv update: $DBI::errstr";
  $sth->execute($mod, "A10","B10")
    or die "ERROR: could not execute csv update: $DBI::errstr";
  return $sth->rows;
}

sub sqlite_update{
  CORE::state $counter = 0;
  my $mod = ($counter++ % 10)+1;
  my $sth = $sqliteDbh->prepare("UPDATE DIST SET distance=? WHERE name1=? AND name2=?")
    or die "ERROR: could not prepare SQLite update: $DBI::errstr";
  $sth->execute($mod, "A10","B10")
    or die "ERROR: could not execute SQLite update: $DBI::errstr";
  return $sth->rows;
}

sub dbm_update{
  CORE::state $counter = 0;
  my $mod = ($counter++ % 10)+1;
  $$dbmDbh{A10}{B10} = $mod;
  return 1;
}

sub ram_update{
  CORE::state $counter = 0;
  my $mod = ($counter++ % 10)+1;
  $ramHash{A10}{B10} = $mod;
  return 1;
}

is(csv_insert(\@name1,\@name2,\@dist), scalar(@dist), "CSV insert");
is(sqlite_insert(\@name1,\@name2,\@dist), scalar(@dist), "SQLite insert");
is(dbm_insert(\@name1,\@name2,\@dist), scalar(@dist), "dbm insert");
is(ram_insert(\@name1,\@name2,\@dist), scalar(@dist), "ram insert");

is(csv_query(), 9, "CSV query");
is(sqlite_query(), 9, "SQLite query");
is(dbm_query(), 9, "dbm query");
is(ram_query(), 9, "ram query");

is(csv_update(), 1, "CSV update");
is(sqlite_update(), 1, "SQLite update");
is(dbm_update(), 1, "dbm update");
is(ram_update(), 1, "ram update");

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
diag "Comparing update methods";
cmpthese(1e3, { # 1e4
    "SQLite update" => sub{sqlite_update()},
    "CSV update"    => sub{csv_update()},
    "dbm update"    => sub{dbm_update()},
    "ram update"    => sub{ram_update()},
  }
);

diag "Comparing query methods";
cmpthese(1e4, { # 5e3
    "SQLite query"  => sub{sqlite_query()},
    "CSV query"     => sub{csv_query()},
    "dbm query"     => sub{dbm_query()},
    "ram query"     => sub{ram_query()},
  }
);

# Insert methods should be last so that the extra inserts don't affect
# subsequent tests.
diag "Comparing insert methods";
cmpthese(1e2, { # 1e2
    "SQLite insert" => sub{sqlite_insert(\@name1, \@name2, \@dist)},
    "CSV insert"    => sub{csv_insert(\@name1, \@name2, \@dist)},
    "dbm insert"    => sub{dbm_insert(\@name1, \@name2, \@dist)},
    "ram insert"    => sub{ram_insert(\@name1, \@name2, \@dist)},
  }
);

