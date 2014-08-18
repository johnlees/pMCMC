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

my $speedupfile = "speedupfile.txt";
my $evaltimefile = "evaltimefile.txt";
my $evalspeedup = "evalspeedup.txt";

my $eDepth_script = "/media/Shared/Documents/MCMC/svn/parallel_mcmc/Perl_code/expected_depth_ladder.pl";

print "Run number?\n";
my $run = <STDIN>;
chomp ($run);

print "Speedup benchmark time?\n";
my $benchT = <STDIN>;
chomp ($benchT);

my $N = 0;
#my $us_per_iteration = (1991.3598136/(18000000*2000))*1000*1000;
my $us_per_iteration = (1991.3598136/(18*2000));

open (EFFICIENCIES, "efficiencies.txt") || die("Couldn't open efficiencies.txt\n");

while (my $linein = <EFFICIENCIES>) { 
	chomp($linein);
	my ($Processor, $Efficiency) = split(/\s+/, $linein);
	$Efficiencies{$Processor} = $Efficiency;
}

close EFFICIENCIES;

chdir("/media/Shared/Documents/MCMC/Empirical results/run$run") || die("Couldn't change to data directory\n");

my @DataFiles = glob 'pMCMC*';

foreach my $DataFile (@DataFiles) {
	if ($DataFile =~ m/pMCMC([0-9]+)_run([0-9]+).out/)
	{
		my $Processors = $1;
		my $Run = $2;
		
		if ($Run > $N) {
			$N = $Run;
		}
		
		open (DATA, $DataFile) || die("Could not open file $DataFile");
		
		my $Waiting;
		my $TimeTaken;
		
		while (my $LineIn = <DATA>) {
			if ($LineIn =~ m/option --waiting with value `([0-9]+)'/) {
				$Waiting = $1;
			}
			elsif ($LineIn =~ m/Time taken: ([0-9]+\.[0-9]+)s/) {
				$TimeTaken = $1;
				$EvalData{$Waiting}{$Processors}{$Run} = $TimeTaken;
				#print ("Waiting=$Waiting Processors=$Processors Run=$Run TimeTaken=$TimeTaken\n");
				if ($Waiting == $benchT) {
					$SpeedupData{$Processors}{$Run} = $TimeTaken;
					#print ("Processors=$Processors Run=$Run TimeTaken=$TimeTaken\n");
				}
			}
		}
		close DATA;
	}
}

open (EVALTIME, ">$evaltimefile") || die("Could not open $evaltimefile");

foreach my $Waiting (sort {$a <=> $b} keys %EvalData) {
	my %N;
	my %Mean;
	my %Error;
	
	#print "Waiting = $Waiting\n";
	
	foreach my $Processor (sort {$a <=> $b} keys %{ $EvalData{$Waiting}}) {
		my $Sum = 0;
		my $SumSquares = 0;
		
		#print "Processor = $Processor\n";
		
		foreach my $Run (sort {$a <=> $b} keys %{ $EvalData{$Waiting}{$Processor}}) {
			#print "Run=$Run\n";
			$Sum += $EvalData{$Waiting}{$Processor}{$Run};
			$SumSquares += ($EvalData{$Waiting}{$Processor}{$Run}**2);
		}
			
		$Mean{$Processor} = $Sum/$N;
		$Error{$Processor} = ((($SumSquares/$N - $Mean{$Processor}**2)/$N)**0.5);
		
		#print "N=$N Mean=$Mean{$Processor} Error=$Error{$Processor}\n";
	}
	
	my $WaitingTime = $Waiting* $us_per_iteration;
	print EVALTIME "$WaitingTime* ";
	
	foreach my $Processor (sort {$a <=> $b} keys %{ $EvalData{$Waiting}}) {
		print EVALTIME "$Mean{$Processor} $Error{$Processor} ";
	}
	
	print EVALTIME "\n";
	
}

close EVALTIME;

open (EVALSPEED, ">$evalspeedup") || die("Could not open $evalspeedup");

foreach my $Waiting (sort {$a <=> $b} keys %EvalData) {
	my %Mean;
	my %Error;
	
	my ($Serial, $SerialFracError);
	
	my $WaitingTime = $Waiting* $us_per_iteration;
	print EVALSPEED "$WaitingTime ";
	#print "Waiting = $Waiting\n";
	
	foreach my $Processor (sort {$a <=> $b} keys %{ $EvalData{$Waiting}}) {
		my $Sum = 0;
		my $SumSquares = 0;
		
		#print "Processor = $Processor\n";
		
		foreach my $Run (sort {$a <=> $b} keys %{ $EvalData{$Waiting}{$Processor}}) {
			#print "Run=$Run\n";
			$Sum += $EvalData{$Waiting}{$Processor}{$Run};
			$SumSquares += ($EvalData{$Waiting}{$Processor}{$Run}**2);
		}
			
		my ($AbsError, $Speedup, $SpeedupAbsError, $EffSpeedup, $EffAbsError);
	
		if ($Processor == 1) {
			$Serial = ($Sum/$N);
			$SerialFracError = ((($SumSquares/$N - $Serial**2)/$N)**0.5)/$Serial;
		
			#print("SerialStdDev=$SerialStdDev SerialAbsError=$SerialAbsError SerialFracError=$SerialFracError\n");
			print ("Serial=$Serial SerialFracError=$SerialFracError\n");
			print EVALSPEED "1 0 ";
		}
		else {
			$Speedup = $Serial/($Sum/$N);
			$AbsError = (($SumSquares/$N - ($Sum/$N)**2)/$N)**0.5;
			$SpeedupAbsError = ((($SerialFracError)**2 + ($AbsError/($Sum/$N))**2)**0.5)*$Speedup;
	    
			print("Speedup=$Speedup AbsError=$AbsError SpeedupAbsError=$SpeedupAbsError\n");
			print EVALSPEED "$Speedup $SpeedupAbsError ";
		}
		
	}
	
	print EVALSPEED "\n";
	
}

close EVALSPEED;

open (SPEEDUP, ">$speedupfile") || die ("Could not open $speedupfile");

my ($Serial, $SerialFracError);

foreach my $Processor (sort {$a <=> $b} keys %SpeedupData) {
	my ($Sum, $SumSquares);
	
	#print ("Processor=$Processor\n");
	
	foreach my $Run (sort {$a <=> $b} keys %{ $SpeedupData{$Processor}}) {
		$Sum += $SpeedupData{$Processor}{$Run};
		$SumSquares += ($SpeedupData{$Processor}{$Run})**2;
		#print("Run=$Run Sum=$Sum SumSquares=$SumSquares\n");
	}
	
	my ($AbsError, $Speedup, $SpeedupAbsError, $EffSpeedup, $EffAbsError);
	
	my $eDepth = `perl $eDepth_script --cores $Processor`;
	my $topSpeed = $eDepth * ($Efficiencies{$Processor}/$Efficiencies{1});
	
	if ($Processor == 1) {
		$Serial = ($Sum/$N);
		$SerialFracError = ((($SumSquares/$N - $Serial**2)/$N)**0.5)/$Serial;
		
		#print("SerialStdDev=$SerialStdDev SerialAbsError=$SerialAbsError SerialFracError=$SerialFracError\n");
		print SPEEDUP "$Processor 1 $SerialFracError 1 $SerialFracError $eDepth $topSpeed\n";
		print ("Serial=$Serial SerialFracError=$SerialFracError\n");
	}
	else {
	    $Speedup = $Serial/($Sum/$N);
	    $AbsError = (($SumSquares/$N - ($Sum/$N)**2)/$N)**0.5;
	    $SpeedupAbsError = ((($SerialFracError)**2 + ($AbsError/($Sum/$N))**2)**0.5)*$Speedup;
	    
	    $EffSpeedup = $Speedup * ($Efficiencies{$Processor}/$Efficiencies{1});
	    $EffAbsError = $SpeedupAbsError * ($Efficiencies{$Processor}/$Efficiencies{1});
	    
	    print SPEEDUP "$Processor $Speedup $SpeedupAbsError $EffSpeedup $EffAbsError $eDepth $topSpeed\n";
	    print("Speedup=$Speedup AbsError=$AbsError SpeedupAbsError=$SpeedupAbsError\n");
	}
}

close SPEEDUP;

exit(0)
