
#include "utilities.h"





sampleConf::sampleConf(gsl_matrix* sitesMatrix,int nr_sites, int nr_seqs){
    nr_of_seg_sites = nr_sites;
    nr_of_seqs = nr_seqs;
    sMatrixSampleConf(sitesMatrix);
    driving_theta = wattersonEst();
    cout << "The watterson estimator is "<< driving_theta<<endl;
    getMutIndices();
    mutation_rate=1;//Default value
//    printVectors();
//    printSMatrix();
    //Call the S and A sample configuration function
}

sampleConf::~sampleConf () {
    gsl_matrix_free(S);
    gsl_matrix_free(Scopy);
    gsl_vector_free(M); 
    gsl_vector_free(Mcopy);
    gsl_vector_free(A); 
    gsl_vector_free(Acopy);
    gsl_vector_free(D); 
    gsl_vector_free(Dcopy);


}

void sampleConf::sMatrixSampleConf(gsl_matrix* sites){
    //Finds the unique sequences and the sample configuration
    std::vector<int> unique(nr_of_seqs);
    std::vector<int> sampCo(nr_of_seqs); 
    
    for (int i = 0; i < nr_of_seqs; i++) {
        unique[i]=-1;
        sampCo[i]=0;
    }
    int nr_uniq_seqs = 0; 
    for (int i = 0; i < nr_of_seqs; i++) {
        for (int j = 0; j < nr_of_seqs; j++){
            if (unique[j]==-1 ){
                //This is an unique sequence 
                unique[j]=i;
                sampCo[nr_uniq_seqs]=1;
                whichA.push_back(j);
                nr_uniq_seqs++;
                break;
            } else {
                //Check if this row in unique is the same as i
                bool theSame = areTheRowsTheSame(sites,i,unique[j]);
                if (theSame) {
                    whichA.push_back(j);
                    //Found a matching row
                    sampCo[j]++;
                    break;
                }
            }
        }
    }
    //We have the unique rows of matrix and the sample configuration
     A = gsl_vector_alloc (nr_uniq_seqs);
     Acopy = gsl_vector_alloc (nr_uniq_seqs); 
    for (int i = 0; i < nr_uniq_seqs; i++) {
        gsl_vector_set(A,i,sampCo[i]);
        gsl_vector_set(Acopy,i,sampCo[i]);
    }
    S = createMatrix(nr_uniq_seqs,nr_of_seg_sites);
    Scopy = createMatrix(nr_uniq_seqs,nr_of_seg_sites);
    for (int i = 0; i < nr_uniq_seqs; i++) {
        for (int j = 0; j < nr_of_seg_sites; j++) {
            gsl_matrix_set(S,i,j,gsl_matrix_get(sites,unique[i],j));
            gsl_matrix_set(Scopy,i,j,gsl_matrix_get(sites,unique[i],j));
        }
    }//Now we have the unique allelels.

    nr_of_uniq_seqs=nr_uniq_seqs;
    curr_nr_of_uniq_seqs=nr_uniq_seqs;
    curr_nr_of_seqs=nr_of_seqs;

    D = gsl_vector_alloc(nr_of_seg_sites);
    Dcopy = gsl_vector_alloc(nr_of_seg_sites);
    for (int i = 0; i < nr_of_seg_sites; i++) {
        double colsum=0;
        for (int j = 0; j < nr_of_uniq_seqs; j++) {
            if (gsl_matrix_get(S,j,i)) {
                colsum=colsum+gsl_vector_get(A,j);
            }
        }
        gsl_vector_set(D,i,colsum);
        gsl_vector_set(Dcopy,i,colsum);
    }
}

void sampleConf::printSMatrix(){
    for ( int j = 0; j < nr_of_uniq_seqs; j++) {
        for (int i = 0; i < nr_of_seg_sites-1; i++) {
            cout<<gsl_matrix_get(S,j,i)<<"\t";
        }
        cout<<gsl_matrix_get(S,j,nr_of_seg_sites-1)<<endl;
    }
} 

void sampleConf::printVectors(){
    cout<<"M\tA\tD"<<endl;
    for ( int j = 0; j < nr_of_uniq_seqs; j++) {
        if (j>=nr_of_seg_sites){
            cout<<gsl_vector_get(M,j)<<"\t"<<gsl_vector_get(A,j)<<endl;
        }else{
            cout<<gsl_vector_get(M,j)<<"\t"<<gsl_vector_get(A,j)<<"\t"<<gsl_vector_get(D,j)<<endl;
        }
    }
    cout<<endl;
}

int sampleConf::removeMutation(gsl_rng* rng,int row){
    if (gsl_vector_get(A,row)!=1 || gsl_vector_get(M,row)==0){
        //die!
        cerr << "Tried to remove a mutation on a non mutated allele or an allele that has multiple copies. I am dying now!"<<endl;
        abort();
        //Sanity checks
    }
    //Try to remove a mutation from the row
    int* array = new int[nr_of_seg_sites];
    //Go through the sites that have mutation
    int site = 0;
    for ( int i = 0; i < nr_of_seg_sites; i++) {
        if (gsl_matrix_get(S,row,i)==1) {
            bool some_other_seq_got_the_seg_site = 0;
            for (int j = 0; j < nr_of_uniq_seqs; j++) {
                //Check if some other sequence got this seggreating site also
                //We cannot remove that mutation...
                if (j == row ){
                    continue;
                }else {
                    if (gsl_matrix_get(S,j,i)==1){
                        some_other_seq_got_the_seg_site=1;
                    }
                }
                
            }
            //Check if some other sequence got this seggreating site also
            if (!some_other_seq_got_the_seg_site) {
                //No other sequence got this site
                array[site]=i;
                site++;
            }
        }
    }
    if(site==0){
        //Cannot remove any of the mutations
        cout << "Couldn't remove mutation from this allele there is something wrong with the proposal distritbution."<<endl;
        abort();
    }
    int remove_mut = gsl_rng_uniform_int (rng, site);
    //Now pick the site
    gsl_matrix_set(S,row,array[remove_mut],0);
    //Successfully removed a mutation
    gsl_vector_set(D,array[remove_mut],gsl_vector_get(D,array[remove_mut])-1);
    //Update the allele number at the site
    //Update now the M vector
    int nextRow = isAnyRowTheSame(row);
    if (nextRow==-1){
        //We are still unique 
        gsl_vector_set(M,row,gsl_vector_get(M,row)-1);
    }else {
        gsl_vector_set(M,row,0);
        //Erase the row in the mutation vector
        int te = gsl_vector_get(A,row);
        gsl_vector_set(A,row,0);
        //Erase the row in the sample configuration
        gsl_vector_set(A,nextRow,gsl_vector_get(A,nextRow)+te);
        //Decrease the number of different alleles
        curr_nr_of_uniq_seqs--;
        //Set the row in the S matrix as -1 for clarity
        for (int i = 0; i < nr_of_seg_sites; i++) {
            gsl_matrix_set(S,row,i,-1);
        }
    }

    delete array;
    return(nextRow);
}


void sampleConf::getMutIndices(){
    //Get the number of  mutations in the sequences
    //Must be called after sMatrixSampleConf!
    M = gsl_vector_alloc(nr_of_uniq_seqs);
    Mcopy = gsl_vector_alloc(nr_of_uniq_seqs);
    for (int i = 0; i < nr_of_uniq_seqs; i++) {
        int sum=0;
        for (int j = 0; j < nr_of_seg_sites; j++) {
            sum+=gsl_matrix_get(S,i,j);
        }
        gsl_vector_set(M,i,sum);
        gsl_vector_set(Mcopy,i,sum);
    }
}


int sampleConf::isAnyRowTheSame(int row){
    //Check if there is a row same as row  in matrix S.
    //Returns -1 if there isn't one else return the row number
    return(isAnyRowTheSame(S,row));
}

int sampleConf::isAnyRowTheSame(gsl_matrix* mat,int row){
    //Check if there is a row same as row  in matrix S.
    //Returns -1 if there isn't one else return the row number
    int ret = -1;
    for (int row2 = 0; row2 < nr_of_uniq_seqs; row2++) {
        if (row2==row){
            //The same row 
            continue;
        }
        if (areTheRowsTheSame(mat,row,row2)) {
            ret = row2;
        }
    }
    return(ret);
}

bool sampleConf::areTheRowsTheSame(int row1,int row2){
    //Check if two rows are the same in the matrix S
    return(areTheRowsTheSame(S,row1,row2));
}

bool sampleConf::areTheRowsTheSame(gsl_matrix* mat,int row1,int row2){
    //Check if two rows are the same in the matrix mat
    bool ret = 1;
    for ( int i = 0; i < nr_of_seg_sites; i++) {
        if (gsl_matrix_get(mat,row1,i)!=gsl_matrix_get(mat,row2,i)) {
            ret = 0;
        }
    }
    return(ret);
}

void sampleConf::coalescent(int row){
    //Coalescent the row allele
    if (gsl_vector_get(A,row)<=1){
        //die!
        cerr << "Must have multiple copies to coalescence. I am dying now!"<<endl;
        abort();
        //Sanity checks
    }
    for (int i = 0; i < nr_of_seg_sites; i++) {
        //Update the number of sequences that have particular seggreating site
        if (gsl_matrix_get(S,row,i)==1){
            gsl_vector_set(D,i,gsl_vector_get(D,i)-1);
        }
    }
    gsl_vector_set(A,row,gsl_vector_get(A,row)-1);
    curr_nr_of_seqs--;
}

bool sampleConf::canWeMutateThisSeq (int row){
    bool answer = 0;
    for (int i = 0; i < nr_of_seg_sites; i++) {
            if (gsl_matrix_get(S,row,i) == 1 && gsl_vector_get(D,i) == 1) {
                answer=1;
                break; //Found a sequence
            }
    }
    return(answer);
}


//double sampleConf::SDSpecUnormProb(int row){
//    bool debug = 0;
//    if (debug) {
//        cout<<"The row is   "<< row<<endl;
//        cout<<"The A row is "<<gsl_vector_get(A,row)<<endl;
//        cout<<"The M row is "<<gsl_vector_get(M,row)<<endl;
//        cout<<"D is         ";
//        for (int i = 0; i < nr_of_seg_sites; i++) {
//            cout << gsl_vector_get(D,i)<<"\t";
//        }
//        cout<<endl<<endl;
//    }
//    if (gsl_vector_get(A,row)>=2 ){
//        //Coalescent first
//        return((gsl_vector_get(A,row)));
//    } else if (gsl_vector_get(M,row)>0 && gsl_vector_get(A,row)==1){
//        //One allele with mutation
//        if (canWeMutateThisSeq(row)) {
//            //Can we remove one of the mutations
//            return((gsl_vector_get(A,row)));
//        }else {
//            return(0);
//        }
//    } else {
//        return(0);
//    } 
//}
//
//const double* sampleConf::SDunormProb(){
//    bool debug =0;
//    //Returns the probability for a given S and nr_of_seqs
//    double* out = new double [nr_of_uniq_seqs];
//    double su = 0;
//    for (int i = 0; i < nr_of_uniq_seqs ; i++) {
//        out[i] = SDSpecUnormProb(i);
//        su+=out[i];
//    }
//    if (debug){
//        cout << "The unormalized denisity is ";
//        for (int i = 0; i < nr_of_uniq_seqs; i++) {
//            cout<<out[i]<<"\t";
//        }
//        cout<<endl;
//    }
//    for (int i = 0; i < nr_of_uniq_seqs ; i++) {
//        out[i] = out[i]/su; //Replace this for an expression for the normalized denisty
//    }
//
//    return(out);
//}

int sampleConf::simulateCoal(gsl_rng * rng){
    //Simulates one genological event 
    //Return 0 for stopping
    //Return 1 for mutations
    //Return 2 for coalescent
    //Return 3 for error
    if (curr_nr_of_seqs==1){
        return(0);
    }
    //Simulate the genealogical event
    double curr_nr_of_seqs_doub  = double (curr_nr_of_seqs);
    double time =gsl_ran_exponential(rng,1/(curr_nr_of_seqs_doub*(curr_nr_of_seqs_doub-1+mutation_rate)/2));
    coal_times.push_back(time);
    //Simulate which allele category will be next
    const double*  probs = HUWSpecNormProbs();
    unsigned int* ra_sample = new unsigned int[nr_of_uniq_seqs];
    gsl_ran_multinomial (rng,nr_of_uniq_seqs,1,probs, ra_sample);
    int which_allele=-1;
    for (int i = 0; i < nr_of_uniq_seqs; i++) {
        if (ra_sample[i]){
            which_allele=i;
        }
    }
    if (which_allele==-1){
        cout << "Got a non allele to choose....\n"<<endl;
        for (int i = 0; i < nr_of_uniq_seqs; i++) {
            cout<< probs[i]<<endl;
        }
        //This shouldn't happen
        abort();
    }
    
   log_prob_imp_tree.push_back(log(probs[which_allele])); 

    delete [] probs;
    delete ra_sample;
    allele_seq.push_back(which_allele);
    //Now coalescent or remove mutation
    if (gsl_vector_get(M,which_allele)>=1 && gsl_vector_get(A,which_allele)==1  ){
        //I am making the assumption that the proposal distribution will give allele that 
        //can be cleaned of mutations....
        //Single copy that has mutations that are removable
        int new_allele = removeMutation(rng,which_allele);
        
        //Calculate the probability of this particular path
        double p1 = log(mutation_rate)-log(curr_nr_of_seqs-1+mutation_rate);
        double p2 = 50000;
        if (which_allele==new_allele || new_allele==-1){
            p2 = log(1)-log(curr_nr_of_seqs);
        }else {
            p2 = log(gsl_vector_get(A,new_allele))-log(curr_nr_of_seqs);
        }
           // cout <<"curr_nr:"<< curr_nr_of_seqs <<endl;
           // cout <<"p1:"<< exp(p1) <<endl;
           // cout <<"p2:"<< p2 <<endl;
        //    cout <<"new_allele"<< new_allele <<endl;
        //    cout <<"new_allele"<< which_allele <<endl;
        //nr of sequences shouldn't change when removing mutations
        //Append the prob
        log_prob_hist.push_back(p1+p2);
        
        before_all.push_back(which_allele);
        after_all.push_back(new_allele);
        which_event.push_back(1);
        return(1);
    } else if (gsl_vector_get(A,which_allele)>1) {
        //Multiple copies coalescent first
        
        //Start by calculate the probability of this particular path
        //The coalescent prob
        double p1 = -log(curr_nr_of_seqs-1+mutation_rate);
        //Then the category specific prob
        double p2 = log((gsl_vector_get(A,which_allele)-1));
        //Append the prob
        log_prob_hist.push_back(p1+p2);

        coalescent(which_allele);
        which_event.push_back(0);
        before_all.push_back(-55); //For indexing purposes
        after_all.push_back(-55);
        return(2);
    } else {
        cerr <<"This shouldn't happen"<<endl;
        return(3);
    }
}


void sampleConf::clearCoal(){
    //Add method to clear the coalescent vectors
    coal_times.clear();
    allele_seq.clear();
    
    which_event.clear();
    whichA.clear();

    before_all.clear();
    after_all.clear();

    log_prob_hist.clear();
    log_prob_imp_tree.clear();

    cond_mut_increase.clear();

    curr_nr_of_uniq_seqs=nr_of_uniq_seqs;
    curr_nr_of_seqs=nr_of_seqs;
    gsl_matrix_memcpy (S,Scopy);
    gsl_vector_memcpy (A,Acopy);
    gsl_vector_memcpy (M,Mcopy);
    gsl_vector_memcpy (D,Dcopy);
} 

void sampleConf::makeCoalTree(gsl_rng * rng){
    //This method makes the genealogical events by 
    //calling simulateCoal. The output is stored in 
    //internal vectors must clear them for the next 
    //iteration
    vector<double> curr_times_for_nodes(2*(nr_of_seqs)-1,0);

    bool debug = 0;

    int event = 0;
    double cu_time = 0;
    preComputeProbReducingMut();
    while (simulateCoal(rng)){
    //Simulate the genoalogical events
        cu_time =cu_time+coal_times[event];
        if (which_event[event]==0) {
            //Coalescent event
            if (debug) {
                cout<<"Coal event"<<endl;
            }
        }else {
            //Mutation event
            if (debug) {
                cout<<"Mutation event"<<endl;
            }
        }
        event++;
    }
}

double sampleConf::logProbHist(){
    double su = 0;
    bool debug = 0;
    for (unsigned int i = 0; i < log_prob_hist.size(); i++) {
        if (debug) {
            if (which_event[i]==0){
                cout <<"eve nr "<<i<<": coal"<<endl;
            }else {
                cout <<"eve nr "<<i<<": mut"<<endl;
            }
                cout <<"aaa: "<< exp(log_prob_hist[i])<<endl<<endl;
        }
        su += log_prob_hist[i];
    }
    return(su);
}

double sampleConf::logProbImpTree(){
    double su = 0;
    for (unsigned int i = 0; i < log_prob_imp_tree.size(); i++) {
        su += log_prob_imp_tree[i];
    }
    return(su);
}

double sampleConf::timeMRCA(){
    double su=0;
    for (unsigned int i = 0; i < coal_times.size(); i++) {
        su+=coal_times[i];
    }
    return(su);
}

double sampleConf::probReduceNrOfMutations(int d){
    //This is p_theta(d) as described in the Hobolth paper:
    //The conditional probability that the most recent event increases the number 
    //of mutant genes by one
    if ( d==0) {
        return(0);
    }else if (d==1) {
        double denom = 1/(curr_nr_of_seqs-1+driving_theta);
        double nom = 0;
        for (int k = 2; k <= curr_nr_of_seqs; k++) {
            nom=nom + ((k-1)/(k-1+driving_theta))/(curr_nr_of_seqs-1);
        }
        return(denom/nom);
    }else if (d<0) {
        cout << "Shouldn't get a negative number"<<endl;
        abort();
    } else {
        //The normal case
        double su1=0;
        double su2=0;
        double fact =0 ;
        for (int k = 2; k <= curr_nr_of_seqs-d+1; k++) {
            fact = gsl_sf_lnchoose(curr_nr_of_seqs-d-1,k-2) - gsl_sf_lnchoose(curr_nr_of_seqs-1,k-1);
            su1+=exp(log(d-1)-log(curr_nr_of_seqs-k)-log(k-1+driving_theta)+fact);
            su2+=exp(-log(k-1+driving_theta)+fact);
        }
        return(su1/su2);
    }
}

void sampleConf::preComputeProbReducingMut(){
    //This is the precomputed p_theta(d) :
    cond_mut_increase.resize(curr_nr_of_seqs);
    for (int d = 0; d < curr_nr_of_seqs; d++) {
        cond_mut_increase[d] = probReduceNrOfMutations(d);
    }
}

double sampleConf::HUWmutProb(int k,int m){
    if (gsl_matrix_get(S,k,m)==1){
        //We have a mutation
        return(cond_mut_increase[gsl_vector_get(D,m)]*gsl_vector_get(A,k)/gsl_vector_get(D,m));
    } else if (gsl_matrix_get(S,k,m)==0){
        //There isn't a mutation
        return((1-cond_mut_increase[gsl_vector_get(D,m)])*gsl_vector_get(A,k)/(curr_nr_of_seqs-gsl_vector_get(D,m)));
    } else {
        cout<<"Calling for probability on an allele that is extinct .";
        abort();
    }
}

double sampleConf::HUWSpecUnormProb(int row){
    bool debug = 0;
    if (debug) {
        cout<<"The row is   "<< row<<endl;
        cout<<"The A row is "<<gsl_vector_get(A,row)<<endl;
        cout<<"The M row is "<<gsl_vector_get(M,row)<<endl;
        cout<<"D is         ";
        for (int i = 0; i < nr_of_seg_sites; i++) {
            cout << gsl_vector_get(D,i)<<"\t";
        }
        cout<<endl<<endl;
    }
    if (gsl_vector_get(A,row)>=2 ){
        //Coalescent first
        double su = 0; 
        for (int i = 0; i < nr_of_seg_sites; i++) {
            su+=HUWmutProb(row,i);
        }
        return(su);
    } else if (gsl_vector_get(M,row)>0 && gsl_vector_get(A,row)==1){
        //One allele with mutation
        if (canWeMutateThisSeq(row)) {
            //Can we remove one of the mutations
            double su = 0; 
            for (int i = 0; i < nr_of_seg_sites; i++) {
                su+=HUWmutProb(row,i);
            }
            return(su);
        }else {
            return(0);
        }
    } else {
        return(0);
    } 
}

const double* sampleConf::HUWSpecNormProbs(){
    bool debug =0;
    //Returns the probability for a given S and nr_of_seqs
    double* out = new double [nr_of_uniq_seqs];
    double su = 0;
    for (int i = 0; i < nr_of_uniq_seqs ; i++) {
        out[i] = HUWSpecUnormProb(i);
        su+=out[i];
    }
    if (debug){
        cout << "The unormalized denisity is ";
        for (int i = 0; i < nr_of_uniq_seqs; i++) {
            cout<<out[i]<<"\t";
        }
        cout<<endl;
    }
    for (int i = 0; i < nr_of_uniq_seqs ; i++) {
        out[i] = out[i]/su; //Replace this for an expression for the normalized denisty
    }
    if (debug){
        cout << "The normalized denisity is ";
        for (int i = 0; i < nr_of_uniq_seqs; i++) {
            cout<<out[i]<<"\t";
        }
        cout<<endl;
    }

    return(out);
}

double sampleConf::wattersonEst(){
    double su = 0;
    double id = 0 ;
    for (int i = 1; i < nr_of_seqs; i++) {
        id = i;
        su+=1/id;
    }
    return(nr_of_seg_sites/su);
} 

using namespace std;

vector<int> getDimMatrix(string file_name) {
  string str;
  ifstream ifs(file_name.c_str());
  int nrRows=0;
  int nrCols=0;
  while(getline (ifs,str)){
      nrRows++;
      if(nrCols==0){
          nrCols=str.size();
      }
  }
  cout << "The matrix has "<<nrRows<<" rows and "<<nrCols <<" columns.\n";
  ifs.close();
  vector<int> out(2);
  out[0] = nrRows;
  out[1] = nrCols;
  return(out);
}

gsl_matrix* getMatrixFromFile(string file_name,int nrows, int nrcols){
   string str;
   ifstream ifs(file_name.c_str());
   gsl_matrix* out = createMatrix(nrows,nrcols);
   int nrline=0;
   //Reading the matrix from file
   while(getline (ifs,str)){
       for (unsigned int i = 0; i < str.size(); i++) {
           char te = str[i];
           gsl_matrix_set(out,nrline,i,atoi(&te));
       }
       nrline++;
   }
  cout << "Done reading the matrix from file "<<file_name<<"\n";
   ifs.close();
   return(out);
}

void sampleConf::updateMutParameter(double the){
    if (the<=0){
        cout << "Cannot use a negative or zero mutation parameter"<<endl;
        abort();
    }
    mutation_rate = the;
}

double sampleConf::estimateLikelihood(gsl_rng * rng,double theta, int nr_of_IP_samples){
    double likelihood = 0;
    updateMutParameter(theta);
    //struct timespec start, end, runtime;
	// Start timing	
	int nr_of_iterations =0 ;
//	clock_gettime(CLOCK_MONOTONIC, &start);
    for (int i = 0; i < nr_of_IP_samples; i++) {
           makeCoalTree(rng);
           //simulate
           likelihood+=exp(logProbHist()-logProbImpTree());
           clearCoal();
           //Clear the simulation and start again
  //          clock_gettime(CLOCK_MONOTONIC, &end);
//            runtime  = diff(start, end);
            nr_of_iterations ++;
//            if (runtime.tv_sec>1) {
//                cout <<"broke it "<<endl;
//                cout << "Got to iteration "<< nr_of_iterations<<endl;
//                break;
//            }
    }    
//	clock_gettime(CLOCK_MONOTONIC, &end);
//	runtime  = diff(start, end);
//	printf("Time taken: %ld.%lds\n", runtime.tv_sec, runtime.tv_nsec);
    return (likelihood/nr_of_iterations);
}

//int main()
//{
//    gsl_rng* rng = makeRng(1); //Remove me!
//    string file_name="hudson1.dat";
//    vector<int> dims= getDimMatrix(file_name);
//    //Get the number of segregating sites and sequneces
//    int nr_of_seg_sites = dims[1];
//    int nr_of_seqs = dims[0];
//    gsl_matrix* Sdup=getMatrixFromFile(file_name,dims[0],dims[1]);
//    //Then load the data file
//    if (nr_of_seg_sites==1){
//        cout << "There is only one seggreating site"<<endl;
//        abort();
//    }
//    //The sampleConf constructor only needs the Sdup matrix 
//    //the sample configuration with duplicates
//    sampleConf sa_co = sampleConf(Sdup,dims[1],dims[0]);
//    double step = .5;
//    int nr_steps = 100;
//    for (int i = 2; i < nr_steps; i++) {
//        cout<<step*i<<"\t"<<sa_co.estimateLikelihood(rng,step*i,500)<<endl;
//    }
//    gsl_rng_free(rng);
//    gsl_matrix_free(Sdup);
//}
//
