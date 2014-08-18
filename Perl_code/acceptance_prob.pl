#!/usr/bin/perl -w
#******************************************************************#
#* $Workfile:   parallel_trees.pl  $ $Revision:   0.1  $          *#
#*                                                                *#
#* Parallel implementation of MCMC                                *#
#******************************************************************#

#******************************************************************#
#* Required modules                                               *#
#******************************************************************#
use 5.006_001;
use strict;
use English qw( -no_match_vars );

use Math::Random qw( random_normal
					random_uniform);
					
use Math::Trig;
use constant PI  => 4 * atan2(1, 1);

#
# Functions
#
sub Propose($$)
{
	my($x, $w) = @_;
	
	# Generate a random number
	my $xp = $x + random_normal(1, 0, $w);
	return($xp);
}

sub LogLikelihood($)
{
	my($x) = @_;
	
	my$ll = pdf($x);
	
	if ($ll != 0) {
		return(log($ll));
	}
	else
	{
		return (-1e16);
	}
}

sub pdf($)
{
	my ($x) = @_;
	
	my $pdf = (2*PI)**-0.5*exp(-0.5*$x**2);
	
	return $pdf;
}

#
# Main
#
my $dimension = 5;
my @x = (1, 2, 3, 4, 5);
my $pAccept = 0;
my $Accepts = 0;

my $iterations = 1000000;
my @output;

print "Variance?\n";
my $variance = <STDIN>;
chomp ($variance);

open(OUTPUT, ">perlout.txt") || die("Could not open perlout.txt\n");

my $cur_lik;
for (my $i = 0; $i<$dimension;$i++) {
	$cur_lik += LogLikelihood($x[$i]);
}

for (my $i = 0; $i<$iterations;$i++)
{
	my $prop_likelihood = 0;
	
	my @xp;
	for (my $j = 0; $j<$dimension; $j++) {
		$xp[$j] = Propose($x[$j], $variance);
		$prop_likelihood = LogLikelihood($xp[$j]);
	}
	
	my $ran_uni = log(random_uniform());
	
	# Accept
	if ($ran_uni < ($prop_likelihood - $cur_lik))
	{
		@x = @xp;
		$Accepts++;
	}
	# Reject
	# Do nothing
	
	for (my $j = 0; $j<$dimension; $j++) {
		print OUTPUT ($x[$j] . " ");
	}
	print OUTPUT "\n";
	
}

close OUTPUT;
$pAccept = $Accepts/$iterations;

#Print output
print("Accept probability for a variance of $variance is $pAccept\n");


exit(0);
