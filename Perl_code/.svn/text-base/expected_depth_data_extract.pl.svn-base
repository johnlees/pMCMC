#!/usr/bin/perl -w

#******************************************************************#
#* Required modules                                               *#
#******************************************************************#
use 5.006_001;
use strict;
use English qw( -no_match_vars );

use Text::CSV_XS;

 my %data;
 
 my $csv = Text::CSV_XS->new ({ binary => 1 }) or
     die "Cannot use CSV: ".Text::CSV_XS->error_diag ();
 open my $fh, "<:encoding(utf8)", "depthForPlotting.csv" or die "depthForPlotting.csv: $!";
 
 while (my $row = $csv->getline ($fh)) {
	 my $processors = $row->[1];
     my $prob = $row->[2];
     my $depth = $row->[3];
     
     $data{$prob}{$processors} = $depth;
 }
 $csv->eof or $csv->error_diag ();
 close $fh;

open (OUTPUT, ">exp_depth.txt") || die ("Could not open exp_depth.txt");

foreach my $prob (sort {$a <=> $b} keys %data) {
	print OUTPUT "$prob";
	
	foreach my $processors (sort {$a <=> $b} keys %{ $data{$prob}}) {
		print OUTPUT " " .$data{$prob}{$processors};
	}
	
	print OUTPUT "\n";
}

close OUTPUT;

exit(0);
