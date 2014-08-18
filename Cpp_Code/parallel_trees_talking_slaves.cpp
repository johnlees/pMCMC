#include "utillities.h"

//For the parallelization 
#include "mpi.h"
#include "globals.h"
struct Glob global = {0,0,0,0,0,0,0,0,"output.txt"};
using namespace std;


int main(int argc, char *argv[]){

	// Timing
	time_t start_time;
	time_t end_time;

	int nr_cores;
	int id;
	double cur_lik;
	int count=0;
	double message [2]={-1,-1}; //the first is the tag and the second is the value
	double message_to_root [3]={-1,-1,-1}; //the first is the tag, second is the value, third is the current val
	int node;

    //Start the MPI stuff
    MPI_Init(&argc, &argv);
    id = MPI::COMM_WORLD.Get_rank ( );
    nr_cores = MPI::COMM_WORLD.Get_size ( );

    if (nr_cores == 0){
        printf("Need to have more than one core to run this program");
        abort();
    }

    //Command line parser
    parseParameters(argc,argv,id);

	ofstream out_file;
    out_file.open (global.outfile.c_str());

    double w=global.variance;
    double x0=0;
    double pAcc=global.acceptp;// Move this somewhere else

    //Random number generator
    gsl_rng* rng = makeRng(global.seed);

    //Calculate the likelihood in the beginning
    cur_lik = logLikelihood(x0);

    gsl_matrix* proc_tree=optimalProcTree(nr_cores,pAcc);   //Option to include the master or not
    gsl_matrix* likelihoods=createMatrix(nr_cores,1);
    gsl_matrix* proposed_val=createMatrix(nr_cores,1);
	
    if (id ==0){
        // Start timing	
        start_time = time (NULL);

        //Talking to the master
        gsl_matrix* output=createMatrix(global.iterations+nr_cores,1);//Maybe not the smartest idea to store this in memory
        gsl_matrix_set(output,0,0,x0);
        while (count<global.iterations){
            double xp = propose(rng,x0,w);
            //Children of the root
            if (!isnan(gsl_matrix_get(proc_tree,0,0))){
                //Accept child
                message[0]=1;
                message[1]=xp;
                //Propose a value here and send it
                MPI::COMM_WORLD.Send(&message,2, MPI_DOUBLE,gsl_matrix_get(proc_tree,0,0)-1, 0);
            } 
            if (!isnan(gsl_matrix_get(proc_tree,0,1))){
                //Reject child
                message[0]=1;
                message[1]=x0;
                MPI::COMM_WORLD.Send(&message,2, MPI_DOUBLE,gsl_matrix_get(proc_tree,0,1)-1, 0);
            } 
            //Calculate the likelihood for the root
            gsl_matrix_set(likelihoods,0,0,logLikelihood(xp));
            gsl_matrix_set(proposed_val,0,0,xp);

            for ( int i = 1; i < nr_cores; i++) { 
                /* receive messages from the slaves */
                MPI::COMM_WORLD.Recv(&message_to_root,3, MPI_DOUBLE,i, 0);
                gsl_matrix_set(likelihoods,i,0,message_to_root[1]);
                gsl_matrix_set(proposed_val,i,0,message_to_root[2]);
            }
            /*
             *
             * We have now calculated the likelihoods for one iteration now
             *
             * */
            node=0;
            while (1){
                count++;
                if (log(gsl_rng_uniform(rng))<(gsl_matrix_get(likelihoods,node,0)-cur_lik)) {
                    // Check for an acceptance, update it as next state
                    gsl_matrix_set(output,count,0,gsl_matrix_get(proposed_val,node,0));
                    cur_lik=gsl_matrix_get(likelihoods,node,0);
                    //Check for a node to the left, and move to it unless at the end of the current tree
                    if (!isnan(gsl_matrix_get(proc_tree,node,0))) {
                        //Check if there is an accept child
                        node=gsl_matrix_get(proc_tree,node,0)-1;
                    } else {
                        //No child, stop traversing the tree
                        break;
                    }
                } else {
                    // Otherwise a rejection, in which case the current state is also the next state
                    gsl_matrix_set(output,count,0,gsl_matrix_get(output,count-1,0));
                    if (!isnan(gsl_matrix_get(proc_tree,node,1))) {
                        //Check if there is a reject child
                        node=gsl_matrix_get(proc_tree,node,1)-1;
                    } else {
                        //No child, stop traversing the tree
                        break;
                    }
                }
            }
            x0=gsl_matrix_get(output,count,0);

        }
        /*
         *
         *Finishing up now
         *
         * */
        // End timing
        end_time = time (NULL);
        double secs = end_time - start_time;
        printf("Time taken: %.0fs\n", secs);

        for ( int i = 1; i < nr_cores; i++) { 
            /* Terminating the slaves */
            message[0]=0;
            message[1]=1;
            MPI::COMM_WORLD.Send(&message,2, MPI_DOUBLE,i, 0);
        }
        for (int k = 0; k < global.iterations; k++) {
            /*Print out the results*/
           out_file<< gsl_matrix_get(output,k,0)<<"\n";
       }
       out_file.close();
    } else {
        //Talking to a slave 
        while (1){
            //Listen for a job
            MPI::COMM_WORLD.Recv( &message,2, MPI_DOUBLE,MPI::ANY_SOURCE, 0);
            if (message[0]==1){
                // 1 means keep working, run the likelihood and return it
                double slx0;
                double slxp;
                slx0=message[1];
                slxp=propose(rng,slx0,w);
                //Children of the slave
                if (!isnan(gsl_matrix_get(proc_tree,id,0))){
                    //Accept child
                    message[0]=1;
                    message[1]=slxp;
                    MPI::COMM_WORLD.Send(&message,2, MPI_DOUBLE,gsl_matrix_get(proc_tree,id,0)-1, 0);
                } 
                if (!isnan(gsl_matrix_get(proc_tree,id,1))){
                    //Reject child
                    message[0]=1;
                    message[1]=slx0;
                    MPI::COMM_WORLD.Send(&message,2, MPI_DOUBLE,gsl_matrix_get(proc_tree,id,1)-1, 0);
                } 
                message_to_root[0]=1;
                message_to_root[1]=logLikelihood(slxp);
                message_to_root[2]=slxp;
                MPI::COMM_WORLD.Send( &message_to_root,3, MPI_DOUBLE,0, 0);
            }else if (message[0]==0) {
                // 0 means stop working
                break;
            } 
        }
    }
    MPI::Finalize ( );
};
