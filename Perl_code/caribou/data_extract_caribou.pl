#!/usr/bin/perl -w

#******************************************************************#
#* Required modules                                               *#
#******************************************************************#
use 5.006_001;
use strict;
use English qw( -no_match_vars );

my %EvalData;
my %SpeedupData;
my %Efficiencies;

my $serial_time = 43.51;

my $acceptfile = "acceptfile.txt";

print "Run number?\n";
my $run = <STDIN>;
chomp ($run);

my $N = 0;
#my $us_per_iteration = (1991.3598136/(18000000*2000))*1000*1000;
my $us_per_iteration = (1991.3598136/(18*2000));

open (EFFICIENCIES, "efficiencies.txt") || die("Couldn't open efficiencies.txt\n");

while (my $linein = <EFFICIENCIES>) { 
	chomp($linein);
	my ($accept, $Efficiency) = split(/\s+/, $linein);
	$Efficiencies{$accept} = $Efficiency;
}

close EFFICIENCIES;

chdir("/media/Shared/Documents/MCMC/Empirical results/run$run") || die("Couldn't change to data directory\n");

my @DataFiles = glob 'pMCMC*';

foreach my $DataFile (@DataFiles) {
	if ($DataFile =~ m/pMCMC([0-9]+)_run([0-9]+).out/)
	{
		my $Processors = $1;
		my $Run = $2;
		
		if ($Processors == 1) {
			next;
		}
		
		if ($Run > $N) {
			$N = $Run;
		}
		
		open (DATA, $DataFile) || die("Could not open file $DataFile");
		
		my $accept;
		my $TimeTaken;
		
		while (my $LineIn = <DATA>) {
			if ($LineIn =~ m/option --acceptprob with value `(.+)'/) {
				$accept = $1;
			}
			elsif ($LineIn =~ m/Time taken: ([0-9]+\.[0-9]+)s/) {
				$TimeTaken = $1;
				$EvalData{$accept}{$Processors}{$Run} = $TimeTaken;
				#print ("accept=$accept Processors=$Processors Run=$Run TimeTaken=$TimeTaken\n");
			}
		}
		close DATA;
	}
}

open (ACCEPTS, ">$acceptfile") || die("Could not open $acceptfile");

foreach my $accept (sort {$a <=> $b} keys %EvalData) {
	my %N;
	my %Speedup;
	my %Error;
	
	#print "accept = $accept\n";
	
	foreach my $Processor (sort {$a <=> $b} keys %{ $EvalData{$accept}}) {
		my $Sum = 0;
		my $SumSquares = 0;
		
		#print "Processor = $Processor\n";
		
		foreach my $Run (sort {$a <=> $b} keys %{ $EvalData{$accept}{$Processor}}) {
			#print "Run=$Run\n";
			$Sum += $EvalData{$accept}{$Processor}{$Run};
			$SumSquares += ($EvalData{$accept}{$Processor}{$Run}**2);
		}
			
		$Speedup{$Processor} = $serial_time/($Sum/$N);
		$Error{$Processor} = ((($SumSquares/$N - $Speedup{$Processor}**2)/$N)**0.5)*(($Sum/$N)/$serial_time);
		
		#print "N=$N Speedup=$Speedup{$Processor} Error=$Error{$Processor}\n";
	}
	
	print ACCEPTS "$accept " . $Efficiencies{$accept};
	
	foreach my $Processor (sort {$a <=> $b} keys %{ $EvalData{$accept}}) {
		my $CorrectedSpeedup = $Speedup{$Processor} * $Efficiencies{$accept};
		my $CorrectedError = $Error{$Processor} * $Efficiencies{$accept};
		print ACCEPTS " $CorrectedSpeedup $CorrectedError";
	}
	
	print ACCEPTS "\n";
	
}

close ACCEPTS;

exit(0);
