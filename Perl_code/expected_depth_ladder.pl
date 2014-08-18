#!/usr/bin/perl -w

#******************************************************************#
#* Required modules                                               *#
#******************************************************************#
use 5.006_001;
use strict;
use English qw( -no_match_vars );

my $n = 20;
my $sigma = 0.001;

sub prob($$$$) {
	my ($n, $i, $s, $sigma) = @_;
	
	my $numerator = ($n - $i + 1)*$sigma*($s**$$i);
	
	my $denominator = 1 + ($sigma*$s**2)/(($s-1)**2) * ($s**$n + $n/$s - ($n + 1));
	
	my $probability = $numerator / $denominator;
	
	return($probability);
}

open(OUT, ">outval.dat") || die("Could not open output");

for (my $i = 0; $i <= $n; $i++) {
	print OUT "$i ";
	
	for (my $s = 0.5; $s <= 2; $s *= 2) {
		my $prob = prob($n, $i, $s, $sigma);
		print OUT "$prob ";
	}
	
	print OUT "\n";
}
close OUT;

