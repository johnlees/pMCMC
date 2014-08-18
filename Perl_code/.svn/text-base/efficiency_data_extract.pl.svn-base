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
 open my $fh, "<:encoding(utf8)", "plotEffectiveSampleRate.csv" or die "plotEffectiveSampleRate.csv: $!";
 
 while (my $row = $csv->getline ($fh)) {
	 my $processors = $row->[1];
     my $prob = $row->[2];
     my $efficiency = $row->[4];
     
     $data{$prob}{$processors} = $efficiency;
 }
 $csv->eof or $csv->error_diag ();
 close $fh;

open (OUTPUT, ">eff_plot.txt") || die ("Could not open eff_plot.txt");

foreach my $prob (sort {$a <=> $b} keys %data) {
	print OUTPUT "$prob";
	
	foreach my $processors (sort {$a <=> $b} keys %{ $data{$prob}}) {
		print OUTPUT " " .$data{$prob}{$processors};
	}
	
	print OUTPUT "\n";
}

close OUTPUT;

exit(0);
