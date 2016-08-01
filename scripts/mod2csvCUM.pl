#!/usr/bin/perl
use strict;
use warnings;
use open qw< :encoding(UTF-8) >;

# User-inputted names
my $vol		= "outputVOL.dat";
#my $csv		= "../share/out/budgets.csv";
my $csv 	= "../tmp/cumulative_budget.csv";

# Slurp in the contents of the indexing file
#my $index	= "../tmp/outputVOL.txt";
my $index 	= "../tmp/outputVOL.2.txt";
my $handle	= undef;
open ($handle, "<", $index)	|| die "$0: can't open $index for reading: $!";
	my @indx	= <$handle>;
close ($handle)			|| die "$index: $!";
$handle		= undef;

# Strip out unnecessary basenames
my @paths;
my $path;
my @hashs;
my $hash;
foreach (@indx) {
	($path)	= ($_ =~ /^(.*)output.dat$/);
	push @paths, $path;
	($hash)	= ($_ =~ /^.*(TR.*)\/output.dat$/);
	push @hashs, $hash;
}

# Read in and write out values
my $out			= 1;
my $inout		= 1;
my $switchvalnams	= 0;
my $valname;
my $val;
my $count		= 0;
foreach (@paths) {
	my $fil		= $_.$vol;
	open ($handle, "<", $fil)	|| die "$0: can't open $fil for reading: $!";
		my @budg	= <$handle>;
	close ($handle)			|| die "$fil: $!";
	$handle	= undef;
	my @valnames	if ($switchvalnams == 0);
	my @vals;
	$valname	= "hash";
	$val	= $hashs[$count];
	push @valnames, $valname;
	push @vals,	$val;
	foreach (@budg) {
		$out	= 0	if (/OUT:/);
		$inout	= 0	if (/IN - OUT/);
		if ($inout == 1 && $out == 1) {
			($valname, $val)	= ($_ =~ /^\s+([A-Z\s-]+)\s=\s+([0-9.-]+)\s+.+\s=\s+.+$/);
			push @valnames,	"in".$valname	if ($switchvalnams == 0 && /^\s+([A-Z\s-]+)\s=\s+([0-9.-]+)\s+.+\s=\s+.+$/);
			push @vals,	$val	if (/^\s+([A-Z\s-]+)\s=\s+([0-9.-]+)\s+.+\s=\s+.+$/);
		}
		elsif ($inout == 1 && $out == 0) {
			($valname, $val)	= ($_ =~ /^\s+([A-Z\s-]+)\s=\s+([0-9.-]+)\s+.+\s=\s+.+$/);
			push @valnames,	"out".$valname	if ($switchvalnams == 0 && /^\s+([A-Z\s-]+)\s=\s+([0-9.-]+)\s+.+\s=\s+.+$/);
			push @vals,	$val	if (/^\s+([A-Z\s-]+)\s=\s+([0-9.-]+)\s+.+\s=\s+.+$/);
		}
		else {
			($valname, $val)	= ($_ =~ /^\s+([A-Z\s-]+)\s=\s+([0-9.-]+)\s+.+\s=\s+.+$/);
			push @valnames,	$valname	if ($switchvalnams == 0 && /^\s+([A-Z\s-]+)\s=\s+([0-9.-]+)\s+.+\s=\s+.+$/);
			push @vals,	$val		if (/^\s+([A-Z\s-]+)\s=\s+([0-9.-]+)\s+.+\s=\s+.+$/);
		}
	}
	open ($handle, ">>", $csv)	|| die "$0: can't open $csv for appending: $!";
		local $,	= ',';
		print $handle @valnames	if ($switchvalnams == 0);
		print $handle "\n";
		print $handle @vals;
	close ($handle)			|| die "$csv: $!";
	$handle		= undef;
	$switchvalnams	= 1;
	$count++;
}

