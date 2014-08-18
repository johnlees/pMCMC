#!/usr/bin/perl -w

#******************************************************************#
#* Required modules                                               *#
#******************************************************************#
use 5.006_001;
use strict;
use English qw( -no_match_vars );

use Text::CSV_XS;

 my %lines;
 
 my $csv = Text::CSV_XS->new ({ binary => 1 }) or
     die "Cannot use CSV: ".Text::CSV_XS->error_diag ();
 open my $fh, "<:encoding(utf8)", "effAssymptotic.csv" or die "effAssymptotic.csv: $!";
 
 while (my $row = $csv->getline ($fh)) {
     my $prob = $row->[1];
     my $efficiency = $row->[2];
     
     $lines{$prob} = $efficiency;
 }
 $csv->eof or $csv->error_diag ();
 close $fh;

open (OUTPUT, ">1D_assymp.txt") || die ("Could not open 1D_assymp.txt");

foreach my $prob (sort {$a <=> $b} keys %lines) {
	print OUTPUT "$prob " . $lines{$prob} . "\n";
	
}

close OUTPUT;

exit(0);
