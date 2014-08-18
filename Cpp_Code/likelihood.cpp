#include "utilities.h"

#include <getopt.h>

#include "globals.h"

extern struct Glob global;

double logLikelihood (double x){
    long int i;
    for (i = 0; i < global.waiting; i++) {
        /* Killing time... */
        global.waste += rand() - 0.5;
    }
    return (log(gsl_ran_gaussian_pdf(x,1)));
}

double  propose (gsl_rng* rng,double x, double w){
    return(x+gsl_ran_gaussian (rng,w));
}
