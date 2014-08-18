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

#
# Threading modules
#
use threads;
use threads::shared;

#
# Stats modules
#
#use GD::Graph::histogram;

#
# Prototypes
#
sub killtree($$$);

#
# MCMC functions
#
sub Propose($$)
{
	my($x, $w) = @_;
	
	# Generate a random number
	my $xp = rand(2*$w) - $w + $x;
	return($xp);
}

sub AcceptLikelihood($$$)
{
	my($x, $xp, $waiting) = @_;
	
	my($a) = 0;
	
	# e.g. N(0, 1)
	if (rand() < exp($x**2 - $xp**2))
	{
		$a = 1;
	}
	
	# Simulate a long likelihood calculation time
	for (my $i = 0; $i < $waiting; $i++)
	{
		my $z = 1.1**0.5;
	}
	#sleep($waiting);

	return($a);
}

#
# Parallelisation functions
#
sub NewProcTree()
{
	my @ProcTree;
	
	# Example tree
	$ProcTree[0][0] = 1;
	#$ProcTree[0][1] = 2;
	#$ProcTree[2][0] = 3;
	#$ProcTree[2][1] = 4;
	#$ProcTree[4][1] = 5;
	#$ProcTree[5][1] = 6;
	#$ProcTree[6][1] = 7;
	#$ProcTree[0][1] = 1;
	
	return(@ProcTree);
}

sub pMCMC($$$$$$$)
{
	my ($AcceptancePath, $Threads, $node, $ProcTree, $x, $w, $Waiting) 
	                                                               = @_;
	# Thread kill handler
	$SIG{'KILL'} = sub 
	               { 
					   threads->exit(); 
				   };
	
	# If there is a right (reject) node, recurse into the sub-tree 
	# speculating that the current update will be rejected, so pass the
	# current state as being the next state
	if (defined($$ProcTree[$node][1]))
	{
		#print ("Going to node " . $$ProcTree[$node][1] . " with state $x\n");
		my $lThread = threads->create(\&pMCMC, $AcceptancePath, $Threads, $$ProcTree[$node][1], $ProcTree, $x, $w, $Waiting);
		$$Threads[$$ProcTree[$node][1]] = $lThread->tid();
	}
	
	# Generate proposal
	my $xp = Propose($x, $w);
	
	# If there is a left (accept) node, recurse into the sub-tree 
	# speculating that the current update will be accepted, so pass the
	# proposed state as being the next state
	if (defined($$ProcTree[$node][0]))
	{
		#print ("Going to node " . $$ProcTree[$node][0] . " with state $xp\n");
		my $rThread = threads->create(\&pMCMC, $AcceptancePath, $Threads, $$ProcTree[$node][0], $ProcTree, $xp, $w, $Waiting);
		$$Threads[$$ProcTree[$node][0]] = $rThread->tid();
	}
	
	# Compute whether the update will be accepted, and store this
	# information in an array shared by all threads
	my $a = AcceptLikelihood($x, $xp, $Waiting);
	$$AcceptancePath[$node] = join(':', $x, $xp, $a);
	#print("Node $node:  " . $$AcceptancePath[$node] . "\n");
	
	
}

sub killtree ($$$)
{
	my ($node, $Threads, $ProcTree) = @_;
	
	# Kill anything in the left sub-tree
	#print("Killing node $node downwards\n");
	if (defined($$ProcTree[$node][0]))
	{
		killtree($$ProcTree[$node][0], $Threads, $ProcTree);
	}
	
	# Kill anything in the right sub-tree
	if (defined($$ProcTree[$node][1]))
	{
		killtree($$ProcTree[$node][1], $Threads, $ProcTree);
	}
	
	# Kill the current node, by sending a KILL signal to the thread
	if (defined($$Threads[$node]))
	{
		#print("Kill thread " . $$Threads[$node] . " for node $node\n");
		my $KillNode = threads->object("$$Threads[$node]");
		$KillNode->kill('KILL')->detach();
	}
	
}

#******************************************************************#
#* Main                                                           *#
#******************************************************************#

my $start = time;

# Set up example processor tree
my @ProcTree = NewProcTree();

# Parameters for testing pMCMC
#my $NumberCores = 8;
my $Waiting = 1;

# Parameters for MCMC
my $N = 4000;
my $count = 0;
my @X;
my $accepts = 0;

$X[0] = 0; # Initial state
my $w = 2; # Random walk max step size

# Main MCMC loop
while ($count < $N)
{
	my $x = $X[$count];
	my $node = 0;
	my @AcceptancePath :shared;
	my @Threads :shared;
	
	my $rootThread = threads->create(\&pMCMC, \@AcceptancePath, \@Threads, $node, \@ProcTree, $x, $w, $Waiting);
	$rootThread->join();
	#$Threads[0] = $rootThread->tid();
	#print ("Node Thread\n");
	#for (my $i=0; $i<scalar(@Threads); $i++)
	#{
	#	if (defined($Threads[$i]))
	#	{
	#		print ("$i $Threads[$i]\n");
	#	}
	#	else
	#	{
	#		print("$i UNDEF\n");
	#	}
	#}
	#print("\n");
	# Follow the path
	while(1)
	{
		$count++;
		
		#print("Update to node $node\n");
		
		my ($x, $xp, $a) = split(':', $AcceptancePath[$node]);
		
		if ($a)
		{
			# If accepted, put the proposed state as the next state and
			# move to the left in the tree if possible
			$X[$count] = $xp;
			$accepts++;
			# Need to kill right parts of the tree here
			if (defined($ProcTree[$node][1]))
			{
				killtree($ProcTree[$node][1], \@Threads, \@ProcTree);
			}
			
			if (defined($ProcTree[$node][0]))
			{
				$node = $ProcTree[$node][0];
				#print("Joining node: $node\n");
				
				# Make sure the next node has finished processing before
				# moving to it
				my $NextNode = threads->object("$Threads[$node]");
				$NextNode->join();
			}
			else
			{
				last;
			}
		}
		else
		{
			# If rejected, remain in the current state, and move to the
			# right in the tree if possible.
			$X[$count] = $x;
			
			# Need to kill right parts of the tree here
			if (defined($ProcTree[$node][0]))
			{
				killtree($ProcTree[$node][0], \@Threads, \@ProcTree);
			}
			
			if (defined($ProcTree[$node][1]))
			{
				$node = $ProcTree[$node][1];
				#print("Joining node: $node\n");
				
				# Make sure the next node has finished processing before
				# moving to it
				my $NextNode = threads->object("$Threads[$node]");
				$NextNode->join();
			}
			# Need to kill left parts of the tree here
			else
			{
				last;
			}
		}
	}
}

#foreach my $x (@X)
#{
#	print ("$x\n");
#}
print("Acceptp: " . ($accepts/$N) ."\n");
print("Time taken for parallel: " . (time - $start) . "s\n");

#open (OUTPUT, ">mcmcarray.txt");
#foreach my $x (@X)
#{
#	print OUTPUT "$x\n";
#}
#close OUTPUT;

exit(0);
