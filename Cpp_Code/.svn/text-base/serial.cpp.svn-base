#include "utillities.h"
#include "globals.h"
struct Glob global = {0,0,0,0,0,0,0,0,"output.txt"};

using namespace std;

int main(int argc, char *argv[]){
	// Timing
	struct timespec start, end, runtime;
	// Start timing	
	clock_gettime(CLOCK_MONOTONIC, &start);
	
	int dimension=5;

	double x0[] = {1, 2, 3, 4, 5};
	double cur_lik = 0;
	double x[dimension];
	double xp[dimension];
	double new_lik = 0;
	long int accepts = 0;
	
	ofstream out_file;
    parseParameters(argc,argv,0);
    //cout<<global.iterations<<endl;
    out_file.open (global.outfile.c_str());

    double w=global.variance;

    gsl_matrix* output=createMatrix(global.iterations+1,dimension);//Maybe not the smartest idea to store this in memory
    gsl_rng* rng = makeRng(0); 
    for (int i = 0; i < dimension; i++) {
		gsl_matrix_set(output,0,i,x0[i]);
		cur_lik += logLikelihood(x0[i]);
	}

	for (int i = 1; i < global.iterations; i++) {
	    new_lik = 0;
	    
	    for (int j= 0; j < dimension; j++) {
			x[j]=gsl_matrix_get(output,i-1,j);
			xp[j]=propose (rng,x[j],w);
			new_lik += logLikelihood(xp[j]);
		}
		
	    // Accept
        if (log(gsl_rng_uniform(rng))<(new_lik-cur_lik)) {
            accepts++;
            cur_lik=new_lik;
            for (int j= 0; j < dimension; j++) {
				gsl_matrix_set(output,i,j,xp[j]);
			}
		}
		// Reject
        else {
            for (int j= 0; j < dimension; j++) {
				gsl_matrix_set(output,i,j,x[j]);
			}
        }
    }

    // End timing
	clock_gettime(CLOCK_MONOTONIC, &end);
	runtime  = diff(start, end);
	printf("Time taken: %ld.%lds\n", runtime.tv_sec, runtime.tv_nsec);

	double pAccept = accepts;
	pAccept /= global.iterations;
		
	printf("Actual average accept rate %f\n", pAccept);

    for (int k = 0; k < global.iterations; k++) {
		/*Print out the results*/
		for (int j = 0; j < dimension; j++) {
			out_file<< gsl_matrix_get(output, k, j) << " ";
		}
		out_file<<"\n";
	}
    out_file.close();
}
