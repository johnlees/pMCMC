library(snow)
sink("pmcmc.out", append=TRUE, split=TRUE)

##################################################
# parallel MCMC comparison 

ProposeAccept<-function(x=0,w=1,Waiting=1)
{
	#example N(0,1)
	xp<-x+w*(2*runif(1)-1)
	a<-(runif(1)<exp( (x^2-xp^2)/2 ))
	#to test the elgorithm, pretend A/R step time-consuming
	for (k in 1:Waiting) {z<-sqrt(1.1)}
	return(list(xp=xp,a=a))
}

Waiting<-matrix(c(1000,2000,5000,10000,20000,50000,100000,200000,500000,1000000))
numbercores<-matrix(c(1, 2, 4, 8, 16, 32))

#For each different number of cores
for (i in 1:dim(numbercores)[1])
{
  print(numbercores[i])
  #Create a cluster if necessary
  if (numbercores[i] != 1)
  {
    cl <- makeCluster(numbercores[i],type="SOCK") 
    clusterSetupRNG(cl)
  }
  
  #For each waiting time (t_e)
  for (j in 1:dim(Waiting)[1])
  {
    print(Waiting[j])

    N<-1000
    count<-1
    X<-matrix(NA,N,1)
    X[1]<-0
    w<-2

    if (numbercores[i] == 1)
    {
      #Standard normal, serial MCMC
      timing<-snow.time(
	for (l in 2:N) {
		x<-X[l-1]
		r<-ProposeAccept(x,w,Waiting)
		if (r$a) 
			{X[l]<-r$xp}
		else 
			{X[l]<-x}
	}
      )
      #plot(X)
      print(timing)
      pdf(paste('timing', numbercores[i], Waiting[j],'.pdf', sep=" "))
      plot(timing)
      dev.off()
    }
    else
    {
      #Standard normal, parallel MCMC
      timing<-snow.time(
	while (count<N) 
	{    
		x<-X[count]
	      r<-clusterCall(cl,ProposeAccept,x,w,Waiting[j])
		a<-0
		for (p in 1:numbercores[i]) 
		{
			count<-count+1
			if (r[[p]]$a) 
				{X[count]<-r[[p]]$xp; break}
			else 
				{X[count]<-x}
		}
	}
      )
      count
      X<-X[1:N] #so get exactly N and dont stop on acceptance etc
      #plot(X)
      print(timing)
      pdf(paste('timing', numbercores[i], Waiting[j],'.pdf', sep=" "))
      plot(timing)
      dev.off()
   }
  }
  
  # Stop the cluster, if necessary
  if (numbercores[i] != 1)
  {
    stopCluster(cl)
  }

}
 

