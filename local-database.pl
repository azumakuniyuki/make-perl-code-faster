#!/usr/bin/env perl
# Benchmark for sliding windows of strings

use strict;
use warnings;
use Benchmark ':all';
use Test::More 'no_plan';
use DBD::SQLite;
use DBD::CSV;
use Data::Dumper;

my $sqliteFilename = "db.sqlite";
my $csvFilename    = "dist.csv";

# clean slate
for my $filename ($sqliteFilename, $csvFilename){
  unlink($filename);
}

my ($sqliteDbh, $csvDbh);
subtest "CreateDbs" => sub{
  $sqliteDbh = DBI->connect("dbi:SQLite:dbname=$sqliteFilename", "", "")
    or BAIL_OUT("Cannot connect DBI:SQLite: $DBI::errstr");
  my $sqliteSth = $sqliteDbh->do("CREATE TABLE DIST(
      name1 TEXT,
      name2 TEXT,
      distance INTEGER
    )
  ")
    or BAIL_OUT("ERROR creating sqlite database: $DBI::errstr");

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

  pass("Create databases");
};

# Create insert data
my(@name1,@name2,@dist);
for my $int(1..100){
  push(@name1, "A$int");
  push(@name2, "B$int");
  push(@dist, $int);
}

sub sqlite_insert{
  my($name1, $name2, $dist)=@_;
  my $numDist = scalar(@$dist);
  for(my $i=0;$i<$numDist;$i++){
    my $sth = $sqliteDbh->prepare("INSERT INTO DIST(name1,name2,distance) VALUES(?,?,?)")
      or die "ERROR: could not prepare insert statement for sqlite: $DBI::errstr";
    $sth->execute($$name1[$i], $$name2[$i], $$dist[$i])
      or die "ERROR: could not execute insert statement for sqlite: $DBI::errstr";
  }
  return $numDist;
}

sub csv_insert{
  my($name1, $name2, $dist)=@_;
  my $numDist = scalar(@$dist);
  for(my $i=0;$i<$numDist;$i++){
    my $sth = $csvDbh->prepare("INSERT INTO DIST(name1,name2,distance) VALUES(?,?,?)")
      or die "ERROR: could not prepare insert statement for csv: $DBI::errstr";
    $sth->execute($$name1[$i], $$name2[$i], $$dist[$i])
      or die "ERROR: could not execute insert statement for csv: $DBI::errstr";
  }
  return $numDist;
}

sub sqlite_query{
  my $sth = $sqliteDbh->prepare("SELECT name1,name2,distance from DIST WHERE name1=? AND name2=?")
    or die "ERROR: could not prepare SQLite query: $DBI::errstr";
  my $res = $sth->execute("A99", "B99")
    or die "ERROR: could not execute SQLite query: $DBI::errstr";
  my $row = $sth->fetchrow_hashref()
    or die "ERROR: could not fetch SQLite query: $DBI::errstr";
  return $$row{distance};
}

sub csv_query{
  my $sth = $csvDbh->prepare("SELECT name1,name2,distance from DIST WHERE name1=? AND name2=?")
    or die "ERROR: could not prepare CSV query: $DBI::errstr";
  my $res = $sth->execute("A99", "B99")
    or die "ERROR: could not execute CSV query: $DBI::errstr";
  my $row = $sth->fetchrow_hashref()
    or die "ERROR: could not fetch CSV query: $DBI::errstr";
  return $$row{distance};
}

sub csv_update{
  CORE::state $counter = 0;
  my $mod = ($counter++ % 10)+1;
  my $sth = $csvDbh->prepare("UPDATE DIST SET distance=? WHERE name1=?")
    or die "ERROR: could not prepare csv update: $DBI::errstr";
  $sth->execute($mod, "A42")
    or die "ERROR: could not execute csv update: $DBI::errstr";
  return 1;
}

sub sqlite_update{
  CORE::state $counter = 0;
  my $mod = ($counter++ % 10)+1;
  my $sth = $sqliteDbh->prepare("UPDATE DIST SET distance=? WHERE name1=?")
    or die "ERROR: could not prepare SQLite update: $DBI::errstr";
  $sth->execute($mod, "A42")
    or die "ERROR: could not execute SQLite update: $DBI::errstr";
  return 1;
}

is(csv_insert(\@name1,\@name2,\@dist), scalar(@dist), "CSV_insert");
is(sqlite_insert(\@name1,\@name2,\@dist), scalar(@dist), "SQLite_insert");

is(csv_query(), 99, "CSV query");
is(sqlite_query(), 99, "SQLite query");

is(csv_update(), 1, "CSV update");
is(sqlite_update(), 1, "SQLite update");

printf("Running with Perl %s on %s\n%s\n", $^V, $^O, '-' x 80);
cmpthese(5e3, {
    "SQLite query"  => sub{sqlite_query()},
    "CSV query"     => sub{csv_query()},
  }
);

cmpthese(1e4, {
    "SQLite update" => sub{sqlite_update()},
    "CSV update"    => sub{csv_update()},
  }
);

cmpthese(1e2, {
    "SQLite insert" => sub{sqlite_insert(\@name1, \@name2, \@dist)},
    "CSV insert"    => sub{csv_insert(\@name1, \@name2, \@dist)},
  }
);

