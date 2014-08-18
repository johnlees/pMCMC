#sink("pmcmc.out", append=TRUE, split=TRUE)

##################################################
# set up tree structure
NewTree<-function(nproc)
{
  # e.g. Balanced tree based on having 7 cores available
  proctree<-matrix(c(2,3,NA,NA,NA,NA), nproc, 2, byrow=TRUE)
  return(proctree)
}

##################################################
# parallel MCMC
Propose<-function(x=0,w=2)
{
  # Propose with a random walk
  xp<-x+rnorm(1,sd=w)
  return(xp=xp)
}

LogLikelihood <- function(x,Waiting=10000000){
	for (k in 1:Waiting) {z<-sqrt(1.1)}
    return(dnorm(x,log=TRUE))
}
LogLikelihoodMPI <- function(Waiting=1000000){
    x <- propmat[mpi.comm.rank(),2] #Master is 0
	for (k in 1:Waiting) {z<-sqrt(1.1)}
    return(dnorm(x,log=TRUE))
}

GenerateProposals<-function(proctree,propmat,row=1, x, w)
{
  # store initial state in proposals matrix
  propmat[row,1] = x
  # check for a right node (reject), generate proposals for the sub-tree
  if (!is.na(proctree[row,2]))
  {
    propmat <- GenerateProposals(proctree, propmat, proctree[row,2], x, w)
  }
  # propose new state, store in proposals matrix
  xp<-Propose(x,w)
  propmat[row,2]=xp
  # check for a left node (accept), generate proposals for the sub-tree
  if (!is.na(proctree[row,1]))
  {
    propmat <- GenerateProposals(proctree, propmat, proctree[row,1], xp, w)
  }
  return(propmat)
}


# Set parameters to test pMCMC
numbercores<-3

snow=0
rmpi=1
# Use snow with network sockets for communication
#cl <- makeCluster(numbercores,type="SOCK") 
if (snow){
    library(snow)
    cl <- makeCluster(numbercores,type="MPI") 
}else if (rmpi) {
    library(Rmpi)
    mpi.spawn.Rslaves(nslaves=3)
    mpi.bcast.Robj2slave(LogLikelihoodMPI)
}else {
    library(multicore)
}
#clusterSetupRNG(cl) HJ hmmm crashes my computer :(

# Set up the optimal tree for the number of processors available
proctree<-NewTree(numbercores)

# MCMC parameters
N<-500
count<-1
X<-matrix(NA,N,1)
X[1]<-0
w<-2
#Proposal tree
propmat<-matrix(NA,numbercores,2)
ti <- 0
curLikelihood <- LogLikelihood(X[1])
timing<-system.time(
  while (count<N) 
  {  
      print(count)
    x<-X[count]
    # Create a matrix of the initial and proposed state for each core
    propmat <- GenerateProposals(proctree, propmat, 1, x, w)
    # Calculate the likelihood for each proposal in the tree simulataneously
    if (snow){
        likelihoods<-clusterApply(cl,x=propmat[,2], LogLikelihood )
    }else if (rmpi) {
        mpi.bcast.Robj2slave(propmat)
        likelihoods <- mpi.remote.exec(LogLikelihoodMPI())
    }else{
        likelihoods<-mclapply(X=propmat[,2], LogLikelihood,mc.cleanup=FALSE)
    }
    # Follow the tree down to the final state
    a<-0
    node<-1
    while (TRUE)
    {
      count<-count+1
      # Check for an acceptance, update it as next state
      if (log(runif(1)) < (likelihoods[[node]]-curLikelihood)) {
          X[count]<-propmat[node,2]
          curLikelihood <- likelihoods[[node]]
          # Check for a node to the left, and move to it unless at the end of the current tree
          if (!is.na(proctree[node,1]))
          {
              node = proctree[node,1]
          }
          else
          {
              break
          }
      }
      else
      {
        # Otherwise a rejection, in which case the current state is also the next state
        X[count]<-X[count-1]

        # Check for a node to the right, and move to it unless at the end of the current tree
        if (!is.na(proctree[node,2]))
        {
          node = proctree[node,2]
        }
        else
        {
          break
        }
      }
    }
  }
)


X<-X[1:N] # to get exactly N
plot(X)
print(timing)
#pdf('timing_diagram.pdf')
#plot(timing)
#dev.off()
# Stop the other processes
if (snow){
    stopCluster(cl)
} else if (rmpi){
    mpi.close.Rslaves()
}
