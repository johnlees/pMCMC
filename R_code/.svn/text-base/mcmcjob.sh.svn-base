#!/bin/bash
#PBS -N pMCMC
#PBS -l walltime=1:20:00
#PBS -l select=4:mpiproc=8
#PBS -m bea

cd $PBS_O_WORKDIR
module load R
R CMD BATCH ~/mcmc/core_time_loop.R
