#!/bin/bash

#PBS -V
#PBS -N pMCMC_4_ntest
#PBS -l walltime=0:20:00
#PBS -l select=1:ncpus=4:mpiprocs=4
#PBS -m bea
#PBS -M john.lees@balliol.ox.ac.uk

cd $PBS_O_WORKDIR

. enable_hal_mpi.sh

time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 1000 --waiting 1000000 --seed -1 
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 10000 --waiting 1000000 --seed -1 
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 100000 --waiting 1000000 --seed -1 
