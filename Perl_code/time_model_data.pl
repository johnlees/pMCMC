#!/usr/bin/perl -w

#******************************************************************#
#* Required modules                                               *#
#******************************************************************#
use 5.006_001;
use strict;
use English qw( -no_match_vars );

my $t_p = 2;
my $t_d = 2;
my $t_c = 2;

my $E = 1.78;
my $K = 2;

my $points = 5000;
my $max = 40;

open(OUTPUT, ">time_model.txt") || die("Couldn't open time_model.txt for writing\n");

for (my $t_e = 0; $t_e<$max; $t_e+=($max/$points)) {
	my $S = ($E*($t_p+$t_e+$t_d)) / (($K-1)*($t_p+2*$t_c) + $t_p + $t_e + $E*$t_d);
	
	print OUTPUT "$t_e $S\n";
}

close OUTPUT
