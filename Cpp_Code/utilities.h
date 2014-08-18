#ifndef __UTILLITIES_H_INCLUDED__
#define __UTILLITIES_H_INCLUDED__

#ifdef WIN32
#include "stdafx.h"
#endif

    //Standard stuff
#include <stdio.h>
#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>
#include <iomanip>
#include <math.h>
#include <sys/time.h>
#include <ctime>
#include <list>

using namespace std;
    //#include <string>
    //The gsl library
#include <gsl/gsl_vector.h>
#include <gsl/gsl_matrix.h>
#include <gsl/gsl_randist.h>
#include <gsl/gsl_sf_gamma.h>



//If windows
#ifdef WIN32
        #ifndef NAN
            static const unsigned long __nan[2] = {0xffffffff, 0x7fffffff};
            #define NAN (*(const float *) __nan)
        #endif
#endif

#ifdef WIN32
#include <process.h>
#endif

#include "globals.h"

#define USING_IP 1




/*
 *
 * utillities.cpp functions 
 *
 * */
gsl_matrix* createMatrix (int nrows,int ncols );
//Create a default gsl matrix 

gsl_rng* makeRng (int seed);
//Allocating memory for the random number generator

#ifdef USING_IP
//The importance sampler class
class   sampleConf {
    public:
    sampleConf(){};                     //Construct with nothing
    sampleConf(gsl_matrix*,int, int);   //The sites, segreating sites and nr of sequences
    ~sampleConf();                     //Construct with nothing
    void printSMatrix();                //Prints the S matrix to the STDOUT
    void printVectors();                 //Prints the M,S and A vectors to the STDOUT
    
    void makeCoalTree(gsl_rng *);    //Call this to make the simulations
    double estimateLikelihood(gsl_rng*,double, int); //Estimates the likelihood for a given mutation rate
    void clearCoal();                    //Clear the simulations
    
    double logProbHist();                   //The probability of the history 
    double logProbImpTree();                //The probability of the proposed tree
   
    void updateMutParameter(double);     //Update the theta parameter
    private:
    
    int nr_of_seg_sites;                  //Nr of different seggreating sites in the S matrix
    int nr_of_seqs;                       //Nr of sequences in the data sets
    int nr_of_uniq_seqs;                  //
    
    int curr_nr_of_uniq_seqs;
    int curr_nr_of_seqs;

    double mutation_rate;

    vector<double> coal_times;          //The coalescent times 
    vector<int> allele_seq;             //The sequnece of alleles that corresponds to the genalogical history
    vector<int> which_event;            //If it is a coalescent or mutation event (C = 0, M = 1).
    vector<int> whichA;                 //Which allele the sequence belongs to 

    vector<int> before_all;             // The allele before mutation removal 
    vector<int> after_all;             // The allele after mutation removal
    
    vector<double> log_prob_hist;             // The log prob of a particular history
    vector<double> log_prob_imp_tree;         // The log prob of importanced sampled tree

    vector<double> cond_mut_increase;            // The precomputed probability that the most recent event increases the number f mutatnt genes in the sample by one needed by the Hobolth scheme. Need to clear this one

    int removeMutation(gsl_rng*,int);   //Remove mutations in the r the S matrix
    
    //GT proposal scheme it gets kinda complicated, don't use me...
    double unNormProb(gsl_rng*,int,double);
    gsl_vector* normProb(gsl_rng*,double);
    
    //SD proposal scheme 
    //double SDSpecUnormProb(int);
    //const double* SDunormProb();

    //HUW, These methods are need to make the IP sampling scheme 
    //as in the Hobolth paper.
    
    double driving_theta;
    double wattersonEst();
    double probReduceNrOfMutations(int);
    void preComputeProbReducingMut();
    
    double HUWmutProb(int,int); 
    double HUWSpecUnormProb(int);
    const double* HUWSpecNormProbs();

    //One iteration of genealogical events
    int simulateCoal(gsl_rng*);
    void coalescent(int);
    
    double timeMRCA();
    
    gsl_matrix* S; //Different allelels
    gsl_matrix* Scopy; //Used to reset the S matrix
    gsl_vector* M; //List of rows that have mutation
    gsl_vector* Mcopy; //Used to reset the M matrix
    gsl_vector* A; //Alleles configuration 
    gsl_vector* Acopy; //Used to reset A matrix
    gsl_vector* D; //Number of alleles that have this mutation 
    gsl_vector* Dcopy; 

    void sMatrixSampleConf(gsl_matrix* sites); //Populate the S and M matrix
    void getMutIndices(); //Populate the M matrix 
    
    int isAnyRowTheSame(int); 
    int isAnyRowTheSame(gsl_matrix*,int); 
    bool areTheRowsTheSame(int,int); 
    bool areTheRowsTheSame(gsl_matrix*,int,int);
    bool canWeMutateThisSeq (int);
};

vector<int> getDimMatrix(string file_name);
gsl_matrix* getMatrixFromFile(string file_name,int nrows, int nrcols);


#endif

#ifdef USING_IP
double logLikelihood (gsl_rng* rng,sampleConf* sa_co,double x);
#else 
double logLikelihood (double x);
#endif
//The ,,main function'' to be called

double  propose (gsl_rng* rng,double x, double w);
//Simulate a draw from the jumping distribution 

void generateProposals (gsl_rng* rng,gsl_matrix* proc_tree,gsl_matrix* prop_mat,int row, double x[], double w, int dimension);
//Given a processor matrix simulating the proposals

gsl_matrix* procTree (int nprocs) ;
//A tempory function

void parseParameters (int argc, char *argv[], int id);
//Parse parameters from the command line

/*
 * 
 * optimal_tree.cpp
 *
 */

gsl_matrix* optimalProcTree (int nprocs, double p);
//Under white noise assumption this finds the optimal tree using the 
//greedy algorithm

timespec diff(timespec start, timespec end);

double string_to_double( const std::string& s );
//converting string to a double 


#endif
