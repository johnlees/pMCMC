#include "utilities.h"

#include <getopt.h>

#include "globals.h"

#include <string.h> //for strcpy
extern struct Glob global;

using namespace std;


extern "C" {
    //Add the c function from geneTree
    double replicate(TREE *t, TREE *s, double theta, double m, long rep);
}



double logLikelihood (TREE *t,TREE *s,double theta) {
    //int nr_of_IS_samples = global.IS_samples;
    int nr_of_IS_samples = global.IS_samples;
    int seed= abs(rand()*500);
    
    if (nr_of_IS_samples<0 && seed<0 ){
        printf("Genetree failed\n"); 
        abort();
    }
    
    if (theta <= 0 ){
        return(0.0);
    }
    double prob = replicate(t,s,theta,1,nr_of_IS_samples);
    return log(prob); 
}  

double  propose (gsl_rng* rng,double x, double w){
    return(x+gsl_ran_gaussian (rng,w));
}
