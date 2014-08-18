#include "utilities.h"
#include <algorithm>
#include <queue>

using namespace std;

//helper datastructure for optimal tree
struct Proc{
	Proc(int par, bool left, double p) : parent(par), lChild(left), logp(p){}
	int parent;
	bool lChild;
	double logp;

};

bool operator>( const Proc& lhs, const Proc& rhs ) {
    //Ordering of the nodes
    return lhs.logp < rhs.logp;
}

gsl_matrix* optimalProcTree (int nprocs, double p) {
    //Finding the optimal tree given number of processors 
    //and p value, assuming the white noise model.
	//First part corresponds to greedySelect in .r code
    //Specify nr of processors and accept probability
	double logp = log(p);
	double logq = log(1-p);
	
	//Queue containing potential nodes
	priority_queue< Proc, vector<Proc>, greater<Proc> > qPotNodes;

	//Insert left and right nodes of the root
	qPotNodes.push(Proc(1,true,logp));
	qPotNodes.push(Proc(1,false,logq));
	
	//Returned matrix
	gsl_matrix* S = createMatrix(nprocs, 2);
	
	for(int i = 2; i <= nprocs; i++){
		Proc toAdd = qPotNodes.top();
		double pToAdd = toAdd.logp;
		int parentNode = toAdd.parent;
		bool leftNode = toAdd.lChild;
		
		qPotNodes.pop();
		
		if (leftNode == true) {
			gsl_matrix_set(S,parentNode-1,0,i);
		}
		else
		{
			gsl_matrix_set(S,parentNode-1,1,i);
		}

		//Add children of toAdd til qPotNodes
		qPotNodes.push(Proc(i, true, pToAdd + logp));
		qPotNodes.push(Proc(i, false, pToAdd + logq));
	}

	return(S);
};
