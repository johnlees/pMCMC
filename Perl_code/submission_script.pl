#!/usr/bin/perl -w

#******************************************************************#
#* Required modules                                               *#
#******************************************************************#
use 5.006_001;
use strict;
use English qw( -no_match_vars );

use Math::Trig;
use constant PI  => 4 * atan2(1, 1);

my @AcceptProbs;
my @ProcArray;
my @WaitingArray;
my @Variances;

print "Iterations?\n";
my $iterations = <STDIN>;
chomp ($iterations);

open(PROCS, "processors.txt") || die("Failed to find processors.txt");

while (my $linein = <PROCS>)
{
	chomp($linein);
	my ($Processor, $AcceptProb, $Variance) = split(/\s+/, $linein);
	push(@ProcArray, $Processor);
	push(@AcceptProbs, $AcceptProb);
	push(@Variances, $Variance);
}

close PROCS;

open(WAIT, "waiting.txt") || die("Failed to find waiting.txt");

while (my $linein = <WAIT>)
{
	chomp($linein);
	push(@WaitingArray, $linein);
}

close WAIT;

for (my $i=0; $i<scalar(@ProcArray); $i++)
{
	my $processors = $ProcArray[$i];
	my $accept = $AcceptProbs[$i];
	#my $variance = (0.5*tan(0.5*PI*$accept))**-1;
	my $variance = $Variances[$i];
	
	open (SCRIPT, ">mpi_sub_$processors.sh");
	print SCRIPT "#!/bin/bash\n\n";
	print SCRIPT "#PBS -V\n";
	
	print SCRIPT "#PBS -N pMCMC_$processors\n";
	
	if ($processors == 1)
	{
		print SCRIPT "#PBS -l walltime=0:80:00\n";
	}
	elsif ($processors < 8)
	{
		print SCRIPT "#PBS -l walltime=0:58:59\n";
	}
	else
	{
		print SCRIPT "#PBS -l walltime=0:35:00\n";
	}
	
	if ($processors < 8)
	{
		print SCRIPT "#PBS -l select=1:ncpus=$processors:mpiprocs=$processors\n";
	}
	else
	{
		my $nodes = $processors / 8;
		print SCRIPT "#PBS -l select=$nodes:ncpus=8:mpiprocs=8\n";
	}
	
	my $longstr = <<'HEADER';
#PBS -m bea
#PBS -M john.lees@balliol.ox.ac.uk

cd $PBS_O_WORKDIR

. enable_hal_mpi.sh

HEADER

	print SCRIPT $longstr;
	
	my $script;
	if ($processors == 1)
	{
		$script = './serial';
	}
	else
	{
		$script = 'time mpirun $MPI_HOSTS ./parallel_trees';
	}
	
	print SCRIPT $script . ' --master 1 --iterations ' .
	$iterations . ' --waiting ' . $WaitingArray[0] . ' --seed -1 --acceptprob ' . 
	$accept . ' --variance ' . $variance . ' --output Chain_proc' . $processors . '_wait' . $WaitingArray[0] 
	. '_run$PBS_ARRAY_INDEX > pMCMC' . $processors . '_run$PBS_ARRAY_INDEX.out' . "\n";
	
	for (my $j = 1; $j < scalar(@WaitingArray); $j++)
	{
		print SCRIPT $script . ' --master 1 --iterations ' .
		$iterations . ' --waiting ' . $WaitingArray[$j] . ' --seed -1 --acceptprob ' . 
		$accept . ' --variance ' . $variance . ' --output Chain_proc' . $processors . '_wait' . $WaitingArray[$j] 
		. '_run$PBS_ARRAY_INDEX >> pMCMC' . $processors . '_run$PBS_ARRAY_INDEX.out' .
		' >> pMCMC' . $processors . '_run$PBS_ARRAY_INDEX.out' . "\n";
	}
	close SCRIPT;
}
