#include "utilities.h"

#include <getopt.h>

#include "globals.h"

//struct Glob global = {0,0,0,0,0,0,0,"output.txt"};

extern struct Glob global;


string convertInt(int number)
{
   stringstream ss;//create a stringstream
   ss << number;//add number to the stream
   return ss.str();//return a string with the contents of the stream
}
string convertDouble(double number)
{
   stringstream ss;//create a stringstream
   ss << number;//add number to the stream
   return ss.str();//return a string with the contents of the stream
}


gsl_matrix* createMatrix (int nrows,int ncols ) {
    /* Making gsl matrices */
	gsl_matrix* S = gsl_matrix_calloc ( nrows, ncols);
	gsl_matrix_set_all(S,NAN);//Setting everything to -1
    return(S);
};

gsl_rng* makeRng (int seed){
    if (seed==-1){
        //Use this when done debugging
        seed = abs(time (NULL) * getpid());
    }
    gsl_rng *rng;
    rng = gsl_rng_alloc (gsl_rng_rand48);   
    gsl_rng_set (rng, seed);                  
    return(rng);
}

//double logLikelihood (double x){
//    long int i;
//    for (i = 0; i < global.waiting; i++) {
//        /* Killing time... */
//        global.waste += rand() - 0.5;
//    }
//    return (log(gsl_ran_gaussian_pdf(x,1)));
//}
//
//double  propose (gsl_rng* rng,double x, double w){
//    return(x+gsl_ran_gaussian (rng,w));
//}

void generateProposals (gsl_rng* rng,gsl_matrix* proc_tree,gsl_matrix* prop_mat,int row, double x[], double w, int dimension){
    //printf("Entered with row=%d\n",row);
    // store initial state in proposals matrix
    for (int i = 0; i < dimension; i++) {
		gsl_matrix_set(prop_mat,row,i*2,x[i]);
	}
    //check for a right node (reject), generate proposals for the sub-tree
    if (!isnan(gsl_matrix_get(proc_tree,row,1))){
        generateProposals(rng,proc_tree,prop_mat,int (gsl_matrix_get(proc_tree,row,1)-1),x,w,dimension); //The matrix has the 1 based indexing
    }
    //propose new state, store in proposals matrix
    double xp[dimension];
    for (int i = 0; i < dimension; i++) {
		xp[i] = propose(rng,x[i],w);
		gsl_matrix_set(prop_mat,row,(i*2)+1,xp[i]);
	}
    //check for a left node (accept), generate proposals for the sub-tree
    if (!isnan(gsl_matrix_get(proc_tree,row,0))){
        generateProposals(rng,proc_tree,prop_mat,int (gsl_matrix_get(proc_tree,row,0)-1),xp,w,dimension);
    }
    //Don't have to return since we are working with the pointer
}


static struct option long_options[] =
 {
     /* These options need an argument. */
     {"master",    required_argument, 0, 'a'},
     {"iterations",    required_argument, 0, 'b'},
     {"waiting",    required_argument, 0, 'c'},
     {"output",    required_argument, 0, 'd'},
     {"seed",    required_argument, 0, 'e'},
     {"acceptprob",  required_argument, 0, 'f'},
     {"variance",  required_argument, 0, 'g'},
     {"issamples",     required_argument,       0, 'h'},
     {0, 0, 0, 0}
};


void help (){
               printf ("run with mpirun -n integer ./parallel_trees \n");
               printf ("option --master 0 or 1\n");
               printf ("option --iterations positive integer \n");
               printf ("option --waiting positive integer \n");
               printf ("option --output string \n");
               printf ("option --seed positive integer or -1 for using the time \n");
               printf ("option --acceptprob double \n");
               printf ("option --variance double \n");
               printf ("option --issamples positive integer \n");
}

void parseParameters (int argc, char *argv[],int id){
    int c;
    while (1){
        /* getopt_long stores the option index here. */
        int option_index = 0;
        c = getopt_long (argc, argv, "abcdefg",long_options, &option_index);
                /* Detect the end of the options. */
        if (c == -1) break;
        switch (c){
            case 0:
           /* If this option set a flag, do nothing else now. */
           if (long_options[option_index].flag != 0)
             break;
           printf ("option %s", long_options[option_index].name);
           if (optarg)
             printf (" with arg %s", optarg);
           printf ("\n");
           break;
         case 'a':
           if (id==0){
               printf ("option --master with value `%s'\n", optarg);
           }
           global.using_master = atoi(optarg);
           break;
         case 'b':
           if (id==0){
               printf ("option --iterations with value `%s'\n", optarg);
           }
           global.iterations = atol(optarg);
           break;
         case 'c':
           if (id==0){
               printf ("option --waiting with value `%s'\n", optarg);
           }
           global.waiting = atol(optarg);
           break;
         case 'd':
           if (id==0){
               printf ("option --output with value `%s'\n", optarg);
           }
           global.outfile = optarg;
           break;
         case 'e':
           if (id==0){
               printf ("option --seed with value `%s'\n", optarg);
            }
           global.seed = atoi(optarg);
           break;
         case 'h':
           if (id==0){
               printf ("option --issamples with value `%s'\n", optarg);
            }
           global.IS_samples = atoi(optarg);
           break;
	case 'f':
           if (id==0){
               printf ("option --acceptprob with value `%s'\n", optarg);
            }
           global.acceptp = atof(optarg);
           break;
	case 'g':
           if (id==0){
               printf ("option --variance with value `%s'\n", optarg);
            }
           global.variance = atof(optarg);
           break;

 
         case '?':
           /* getopt_long already printed an error message. */
           break;
 
         default:
           abort ();
         }
    }
    if (global.verbose_flag) puts ("verbose flag is set");

    if (optind < argc)
     {
       printf ("This is not an option will abort: ");
       while (optind < argc)
         printf ("%s ", argv[optind++]);
       putchar ('\n');
       help();
       abort();
     }
    if (1 == argc)
     {
       help();
       putchar ('\n');
       abort();
     }
}

timespec diff(timespec start, timespec end)
{
	timespec temp;
	if ((end.tv_nsec-start.tv_nsec)<0) {
		temp.tv_sec = end.tv_sec-start.tv_sec-1;
		temp.tv_nsec = 1000000000+end.tv_nsec-start.tv_nsec;
	} else {
		temp.tv_sec = end.tv_sec-start.tv_sec;
		temp.tv_nsec = end.tv_nsec-start.tv_nsec;
	}
	return temp;
}

double string_to_double( const std::string& s )
 {
     std::istringstream i(s);
   double x;
   if (!(i>> std::setprecision(30) >> x))
     return 0;
   return x;
 } 
