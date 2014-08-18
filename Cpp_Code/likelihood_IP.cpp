#include "utilities.h"

#include <getopt.h>

#include "globals.h"


extern struct Glob global;

double logLikelihood (gsl_rng* rng,sampleConf* sa_co,double theta){
    if (theta<=0){
        cout << "I shouldn't see a negative theta value"<<endl;
        abort();
        return (0);
    } else {
        return(log(sa_co->estimateLikelihood(rng,theta,global.IS_samples)));
    }
}

double  propose (gsl_rng* rng,double x, double w){
    return(x+gsl_ran_gaussian (rng,w));
}
