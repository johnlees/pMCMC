#include "utilities.h"

//For the parallelization 
#include "mpi.h"
#include "globals.h"
#include <vector>

struct Glob global = {0,0,0,0,0,0,0,0,10,"output.txt"};

using namespace std;

#ifdef USING_IP
#endif

int main(int argc, char *argv[]){
    
    //Start the MPI stuff
    MPI_Init(&argc, &argv);
    int id = MPI::COMM_WORLD.Get_rank ( );
    int nr_cores = MPI::COMM_WORLD.Get_size ( );

	int dimension=1;

	double cur_lik = 0;
	int count=0;
	double message[dimension+1];
	int node;
	int accepts = 0;

	//Random number generator
	gsl_rng* rng = makeRng(global.seed);


    #ifdef USING_IP
    //string file_name="hudson1.dat";
    string file_name="data_sets/sim_10_seq_theta_1.dat";
    vector<int> dims= getDimMatrix(file_name);
    //Get the number of segregating sites and sequneces
    int nr_of_seg_sites = dims[1];
    int nr_of_seqs = dims[0];
    gsl_matrix* Sdup=getMatrixFromFile(file_name,dims[0],dims[1]);
    //Then load the data file
    if (nr_of_seg_sites==1){
        cout << "There is only one seggreating site"<<endl;
        abort();
    } else if (nr_of_seqs<1){
        cout << "There are no sequences"<<endl;
        abort();
    }
    //The sampleConf constructor only needs the Sdup matr
    //the sample configuration with duplicates
    sampleConf sa_co = sampleConf(Sdup,dims[1],dims[0]);
    #endif
    
    
	// Timing
	struct timespec start, end, runtime;
	// Start timing	
	clock_gettime(CLOCK_MONOTONIC, &start);
	
	// Testing
	std::vector<int> exit_pos;


    if (nr_cores == 0){
        printf("Need to have more than one core to run this program");
        abort();
    }
    
    //Talking to the master
    if (id ==0){
		//Command line parser
		parseParameters(argc,argv,id);

		ofstream out_file;
		out_file.open (global.outfile.c_str());

		double w=global.variance;
		double x0[] = {1, 2, 3, 4, 5};
		double pAcc=global.acceptp;// Move this somewhere else


		//Calculate the likelihood in the beginning
		for (int i = 0; i < dimension; i++) {
            #ifdef USING_IP  
			cur_lik += logLikelihood(rng,&sa_co,x0[i]);
            #else
			cur_lik += logLikelihood(x0[i]);
            #endif
		}

		gsl_matrix* proc_tree=optimalProcTree(nr_cores,pAcc);   //Option to include the master or not
		gsl_matrix* prop_mat=createMatrix(nr_cores+global.using_master,dimension*2);
		gsl_matrix* likelihoods=createMatrix(nr_cores+global.using_master,dimension);
    
        gsl_matrix* output=createMatrix(global.iterations+nr_cores+global.using_master,dimension);//Maybe not the smartest idea to store this in memory
        // The number of nr_cores doesn't divide nicely up to nr of iterations
        for (int i = 0; i < dimension; i++) {
			gsl_matrix_set(output,0,i,x0[i]);
		}
		
		/* print matrix the easy way
		printf("Matrix proc_tree\n");
		gsl_matrix_fprintf(stdout,proc_tree,"%f");
		*/
		
		/* print the matrix the hard way */
		for (int i=0; i<nr_cores; i++) {
			for (int j=0; j<2; j++) {
				printf("%.0f ", gsl_matrix_get(proc_tree,i,j));
			}
			printf("\n");
		}
		printf("\n");

        while (count<global.iterations){
            generateProposals(rng,proc_tree,prop_mat,0,x0,w,dimension);
            for ( int i = 1; i < nr_cores; i++) { 
                /* Send messages to the slaves */
                message[0]=1;
                for (int j = 0; j < dimension; j++) {
					message[j+1]=gsl_matrix_get(prop_mat,i-1+global.using_master,(j*2)+1);
				}
				MPI::COMM_WORLD.Send(&message,dimension+1, MPI_DOUBLE,i, 0);
            }
            if (global.using_master){
                //Are we going to use the master also for computation?
                //The master is the root!
                for (int i = 0; i < dimension; i++) {
                    #ifdef USING_IP
                    gsl_matrix_set(likelihoods,0,i,logLikelihood(rng,&sa_co,exp(gsl_matrix_get(prop_mat,0,(i*2)+1))));
                    #else
					gsl_matrix_set(likelihoods,0,i,logLikelihood(gsl_matrix_get(prop_mat,0,(i*2)+1)));
                    #endif
				}
            }
            for ( int i = 1; i < nr_cores; i++) { 
                /* receive messages from the slaves */
                MPI::COMM_WORLD.Recv(&message,dimension+1, MPI_DOUBLE,i, 0);
                for (int j = 0; j < dimension; j++) {
					gsl_matrix_set(likelihoods,i-1+global.using_master,j,message[j+1]);
				}
            }
            /*
             *
             * We have now calculated the likelihoods for one iteration now
             *
             * */
            node=0;
            while (1){
                count++;
                if (count > global.iterations){
                    //The matrix is not large enough
                    break;
                }
                
                double prop_likelihood = 0;
                for (int i = 0; i < dimension; i++) {
					prop_likelihood += gsl_matrix_get(likelihoods,node,i);
				}
                #ifdef USING_IP
                //double the_old = gsl_matrix_get(output,count-1,0); //Only for one dimension
                //double the_star = gsl_matrix_get(prop_mat,node,+1);
                //cout << "The old "<< the_old << "the star"<<the_star<<endl;
                if (log(gsl_rng_uniform(rng))<(prop_likelihood-cur_lik)) {
                #else
                if (log(gsl_rng_uniform(rng))<(prop_likelihood-cur_lik)) {
                #endif
                    accepts++;
                    cur_lik = 0;
                    // Check for an acceptance, update it as next state
                    for (int i = 0; i < dimension; i++) {
						gsl_matrix_set(output,count,i,gsl_matrix_get(prop_mat,node,(i*2)+1));
						cur_lik+=gsl_matrix_get(likelihoods,node,i);
					}
                    //Check for a node to the left, and move to it unless at the end of the current tree
                    if (!isnan(gsl_matrix_get(proc_tree,node,0))) {
                        //Check if there is an accept child
                        node=gsl_matrix_get(proc_tree,node,0)-1;
                    } else {
                        //No child, stop traversing the tree
                        exit_pos.push_back(node);
                        break;
                    }
                } else {
                    // Otherwise a rejection, in which case the current state is also the next state
                    for (int i = 0; i < dimension; i++) {
						gsl_matrix_set(output,count,i,gsl_matrix_get(output,count-1,i));
					}
                    if (!isnan(gsl_matrix_get(proc_tree,node,1))) {
                        //Check if there is a reject child
                        node=gsl_matrix_get(proc_tree,node,1)-1;
                    } else {
                        //No child, stop traversing the tree
                        exit_pos.push_back(node);
                        break;
                    }
                }
            }
			
			for (int i = 0; i < dimension; i++) {
				x0[i]=gsl_matrix_get(output,count,i);
			}
        }
        /*
         *
         *Finishing up now
         *
         * */

        for ( int i = 1; i < nr_cores; i++) { 
            /* Terminating the slaves */
            message[0]=0;
            message[1]=1;
            MPI::COMM_WORLD.Send(&message, 2, MPI_DOUBLE, i, 0);
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
                #ifdef USING_IP
				out_file<< exp(gsl_matrix_get(output, k, j)) << " ";
                #else
				out_file<< gsl_matrix_get(output, k, j) << " ";
                #endif
			}
			out_file<<"\n";
		}
		out_file.close();
		
		 long int exit_sum = 0;
		
		for (unsigned int k = 0; k < exit_pos.size(); k++) {
			exit_sum += exit_pos.at(k);
		}
		
		double avg_exit = exit_sum;
		avg_exit = avg_exit/exit_pos.size() + 1;
		printf("Average exit point is node %f\n", avg_exit); 
		
	}	
    else {
        //Talking to a slave 
        while (1) {
            //Listen for a job
            MPI::COMM_WORLD.Recv(&message, dimension+1, MPI_DOUBLE, 0, 0);
            if (message[0]==1) {
                // 1 means keep working, run the likelihood and return it
               // clock_gettime(CLOCK_MONOTONIC, &diff_theta_start);
                for (int j = 0; j < dimension; j++) {
                    #ifdef USING_IP
                    message[j+1]=logLikelihood(rng,&sa_co,exp(message[j+1]));
                 //   printf("%f %f   %ld.%ld slave\n",message[j+1],temp, diff_theta_runtime.tv_sec, diff_theta_runtime.tv_nsec);
                    #else
					message[j+1]=logLikelihood(message[j+1]);
                    #endif
				}
                //clock_gettime(CLOCK_MONOTONIC, &diff_theta_end);
               // diff_theta_runtime  = diff(diff_theta_start, diff_theta_end);
				MPI::COMM_WORLD.Send(&message, dimension+1, MPI_DOUBLE, 0, 0);
			}	
            else if (message[0]==0) {
                // 0 means stop working
                break;
            } 
        }
    }
    MPI_Finalize ( );
};
