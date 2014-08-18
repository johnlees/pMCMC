library(mvtnorm)
LogLikelihood <- function(x,Waiting=1){
	for (k in 1:Waiting) {z<-sqrt(1.1)}
    return(dmvnorm(x,mean=rep(0,5),sigma=diag(rep(1,5)),log=TRUE))
}

Propose<-function(x=c(1,2,3,4,5),w=.8)
{
  # Propose with a random walk
  xp<-x+rmvnorm(n=1,rep(0,5),diag(.8,5))
  return(xp=xp)
}

simulateChain <- function(w){
    #The serial one
    X<-matrix(NA,N,5)
    X[1,]<-c(1,2,3,4,5)
    currLik <- LogLikelihood(X[1,])
    for (j in 2:N) {
        print(j)
        x<-X[j-1,]
        xp<-Propose(x,w)
        newLik <- LogLikelihood(xp)
        if (log(runif(1))<(newLik-currLik)) 
            {
                currLik <- newLik
                X[j,]<-xp
            }
        else 
            {
                X[j,]<-x
            }
    }
    return(X)
}

N <- 5000
print(system.time(serial <- simulateChain(w)))
