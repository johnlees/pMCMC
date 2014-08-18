#!/bin/bash

#PBS -V
#PBS -N pMCMC_4
#PBS -l walltime=0:58:59
#PBS -l select=4:ncpus=1:mpiprocs=4
#PBS -m bea
#PBS -M john.lees@balliol.ox.ac.uk

cd $PBS_O_WORKDIR

. enable_hal_mpi.sh

time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 1 --seed -1 --acceptprob 0.1576 --variance 1.48 --output Chain_proc4_wait1_run$PBS_ARRAY_INDEX > pMCMC4_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 1000 --seed -1 --acceptprob 0.1576 --variance 1.48 --output Chain_proc4_wait1000_run$PBS_ARRAY_INDEX >> pMCMC4_run$PBS_ARRAY_INDEX.out >> pMCMC4_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 30000 --seed -1 --acceptprob 0.1576 --variance 1.48 --output Chain_proc4_wait30000_run$PBS_ARRAY_INDEX >> pMCMC4_run$PBS_ARRAY_INDEX.out >> pMCMC4_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 40000 --seed -1 --acceptprob 0.1576 --variance 1.48 --output Chain_proc4_wait40000_run$PBS_ARRAY_INDEX >> pMCMC4_run$PBS_ARRAY_INDEX.out >> pMCMC4_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 50000 --seed -1 --acceptprob 0.1576 --variance 1.48 --output Chain_proc4_wait50000_run$PBS_ARRAY_INDEX >> pMCMC4_run$PBS_ARRAY_INDEX.out >> pMCMC4_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 60000 --seed -1 --acceptprob 0.1576 --variance 1.48 --output Chain_proc4_wait60000_run$PBS_ARRAY_INDEX >> pMCMC4_run$PBS_ARRAY_INDEX.out >> pMCMC4_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 70000 --seed -1 --acceptprob 0.1576 --variance 1.48 --output Chain_proc4_wait70000_run$PBS_ARRAY_INDEX >> pMCMC4_run$PBS_ARRAY_INDEX.out >> pMCMC4_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 100000 --seed -1 --acceptprob 0.1576 --variance 1.48 --output Chain_proc4_wait100000_run$PBS_ARRAY_INDEX >> pMCMC4_run$PBS_ARRAY_INDEX.out >> pMCMC4_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 200000 --seed -1 --acceptprob 0.1576 --variance 1.48 --output Chain_proc4_wait200000_run$PBS_ARRAY_INDEX >> pMCMC4_run$PBS_ARRAY_INDEX.out >> pMCMC4_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 800000 --seed -1 --acceptprob 0.1576 --variance 1.48 --output Chain_proc4_wait800000_run$PBS_ARRAY_INDEX >> pMCMC4_run$PBS_ARRAY_INDEX.out >> pMCMC4_run$PBS_ARRAY_INDEX.out
