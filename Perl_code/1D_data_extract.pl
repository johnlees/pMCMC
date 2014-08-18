#!/usr/bin/perl -w

#******************************************************************#
#* Required modules                                               *#
#******************************************************************#
use 5.006_001;
use strict;
use English qw( -no_match_vars );

use Text::CSV_XS;

 my %points;
 my %lines;
 
 my $csv = Text::CSV_XS->new ({ binary => 1 }) or
     die "Cannot use CSV: ".Text::CSV_XS->error_diag ();
 open my $fh, "<:encoding(utf8)", "eff1dSimulatedPoints.csv" or die "eff1dSimulatedPoints.csv: $!";
 
 while (my $row = $csv->getline ($fh)) {
     my $prob = $row->[1];
     my $efficiency = $row->[2];
     
     $points{$prob} = $efficiency;
 }
 $csv->eof or $csv->error_diag ();
 close $fh;
 
 my $csv2 = Text::CSV_XS->new ({ binary => 1 }) or
     die "Cannot use CSV: ".Text::CSV_XS->error_diag ();
 open my $fh2, "<:encoding(utf8)", "eff1dSmoothed.csv" or die "eff1dSmoothed.csv: $!";
 
 while (my $row = $csv2->getline ($fh2)) {
     my $prob = $row->[1];
     my $efficiency = $row->[2];
     
     $lines{$prob} = $efficiency;
 }
 $csv2->eof or $csv2->error_diag ();
 close $fh2;

open (OUTPUT, ">1D_plot.txt") || die ("Could not open eff_plot.txt");

foreach my $prob (sort {$a <=> $b} keys %lines) {
	print OUTPUT "$prob " . $lines{$prob};
	
	if (defined($points{$prob})) {
		print OUTPUT " " . $points{$prob} . "\n";
	}
	else
	{
		print OUTPUT "\n";
	}
	
}

close OUTPUT;

exit(0);
