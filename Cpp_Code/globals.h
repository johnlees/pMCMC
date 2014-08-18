#ifndef GLOBAL_H // header guards
#define GLOBAL_H
 
// extern tells the compiler this variable is declared elsewhere
 
struct Glob {
    int verbose_flag;

    int iterations;

    int waiting;

    int using_master;

    int seed;

    double waste;

    double acceptp;

    double variance;
    
    int IS_samples;

    std::string outfile;
    
};

#endif
