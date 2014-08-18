#!/usr/bin/perl -w

#******************************************************************#
#* Required modules                                               *#
#******************************************************************#
use 5.006_001;
use strict;
use English qw( -no_match_vars );

use Math::Trig;
use constant PI  => 4 * atan2(1, 1);

my @ProcArray;
my @AcceptArray;
my @variances;

print "Iterations?\n";
my $iterations = <STDIN>;
chomp ($iterations);

print "Waiting?\n";
my $waiting = <STDIN>;
chomp ($waiting);

open(PROCS, "processors.txt") || die("Failed to find processors.txt");

while (my $linein = <PROCS>)
{
	chomp($linein);
	push(@ProcArray, $linein);
}

close PROCS;

open(ACCEPT, "accepts.txt") || die("Failed to find accepts.txt");

while (my $linein = <ACCEPT>)
{
	chomp($linein);
	my ($accept, $variance) = split(/\s+/, $linein);
	push(@AcceptArray, $accept);
	push(@variances, $variance);
}

close ACCEPT;

for (my $i=0; $i<scalar(@ProcArray); $i++)
{
	my $processors = $ProcArray[$i];
	#my $variance = (0.5*tan(0.5*PI*$accept))**-1;
	
	open (SCRIPT, ">mpi_sub_caribou_$processors.sh");
	print SCRIPT "#!/bin/bash\n\n";
	print SCRIPT "#PBS -V\n";
	
	print SCRIPT "#PBS -N pMCMC_$processors\n";
	
	if ($processors == 1)
	{
		print SCRIPT "#PBS -l walltime=0:50:00\n";
	}
	elsif ($processors < 8)
	{
		print SCRIPT "#PBS -l walltime=0:40:00\n";
	}
	else
	{
		print SCRIPT "#PBS -l walltime=0:30:00\n";
	}
	
	if ($processors < 8)
	{
		print SCRIPT "#PBS -l select=1:ncpus=$processors\n";
	}
	else
	{
		my $nodes = $processors / 8;
		print SCRIPT "#PBS -l select=$nodes:ncpus=8\n";
	}
	
	my $longstr = <<'HEADER';
#PBS -m bea
#PBS -M john.lees@balliol.ox.ac.uk

cd $PBS_O_WORKDIR

. ./enable_hal_mpi.sh

HEADER

	print SCRIPT $longstr;
	
	my $script;
	if ($processors == 1)
	{
		$script = './serial';
	}
	else
	{
		$script = "time mpirun -np $processors ./parallel_trees";
	}
	
	print SCRIPT $script . ' --master 1 --iterations ' .
	$iterations . ' --waiting ' . $waiting . ' --seed -1 --acceptprob ' . 
	$AcceptArray[0] . ' --variance ' . $variances[0] . ' --output Chain_proc' . $processors . '_accept' . $AcceptArray[0] 
	. '_run$PBS_ARRAY_INDEX > pMCMC' . $processors . '_run$PBS_ARRAY_INDEX.out' . "\n";
	
	for (my $j = 1; $j < scalar(@AcceptArray); $j++)
	{
		print SCRIPT $script . ' --master 1 --iterations ' .
		$iterations . ' --waiting ' . $waiting . ' --seed -1 --acceptprob ' . 
		$AcceptArray[$j] . ' --variance ' . $variances[$j] . ' --output Chain_proc' . $processors . '_wait' . $AcceptArray[$j] 
		. '_run$PBS_ARRAY_INDEX >> pMCMC' . $processors . '_run$PBS_ARRAY_INDEX.out' .
		' >> pMCMC' . $processors . '_run$PBS_ARRAY_INDEX.out' . "\n";
	}
	close SCRIPT;
}
