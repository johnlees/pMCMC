#!/usr/bin/perl -w

#******************************************************************#
#* Required modules                                               *#
#******************************************************************#
use 5.006_001;
use strict;
use English qw( -no_match_vars );

my @speedupfiles;
my @data;
my %newdata;

while (my $speedupfile = <STDIN>) {
	push(@speedupfiles, $speedupfile);
}

open (SPEEDUPOUT, "combined.txt");

foreach my $speedupfile (@speedupfiles) {
	open (SPEEDUP, $speedupfile);
	
	while (my $linein = <SPEEDUP>) {
		chomp($linein);
		my ($processors, @data) = split($linein, /\s+/);
		push(\$newdata{$processors}, @data);
	}
}

foreach my $processors (sort keys %newdata) {
	print SPEEDUPOUT "$processors " . join($newdata{$processors}, " ") . "\n";
}

exit(0);

