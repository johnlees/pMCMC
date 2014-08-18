#!/bin/bash

#PBS -V
#PBS -N pMCMC_2
#PBS -l walltime=0:58:59
#PBS -l select=2:ncpus=1:mpiprocs=2
#PBS -m bea
#PBS -M john.lees@balliol.ox.ac.uk

cd $PBS_O_WORKDIR

. enable_hal_mpi.sh

time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 1 --seed -1 --acceptprob 0.2 --variance 1.33 --output Chain_proc2_wait1_run$PBS_ARRAY_INDEX > pMCMC2_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 1000 --seed -1 --acceptprob 0.2 --variance 1.33 --output Chain_proc2_wait1000_run$PBS_ARRAY_INDEX >> pMCMC2_run$PBS_ARRAY_INDEX.out >> pMCMC2_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 30000 --seed -1 --acceptprob 0.2 --variance 1.33 --output Chain_proc2_wait30000_run$PBS_ARRAY_INDEX >> pMCMC2_run$PBS_ARRAY_INDEX.out >> pMCMC2_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 40000 --seed -1 --acceptprob 0.2 --variance 1.33 --output Chain_proc2_wait40000_run$PBS_ARRAY_INDEX >> pMCMC2_run$PBS_ARRAY_INDEX.out >> pMCMC2_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 50000 --seed -1 --acceptprob 0.2 --variance 1.33 --output Chain_proc2_wait50000_run$PBS_ARRAY_INDEX >> pMCMC2_run$PBS_ARRAY_INDEX.out >> pMCMC2_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 60000 --seed -1 --acceptprob 0.2 --variance 1.33 --output Chain_proc2_wait60000_run$PBS_ARRAY_INDEX >> pMCMC2_run$PBS_ARRAY_INDEX.out >> pMCMC2_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 70000 --seed -1 --acceptprob 0.2 --variance 1.33 --output Chain_proc2_wait70000_run$PBS_ARRAY_INDEX >> pMCMC2_run$PBS_ARRAY_INDEX.out >> pMCMC2_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 100000 --seed -1 --acceptprob 0.2 --variance 1.33 --output Chain_proc2_wait100000_run$PBS_ARRAY_INDEX >> pMCMC2_run$PBS_ARRAY_INDEX.out >> pMCMC2_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 200000 --seed -1 --acceptprob 0.2 --variance 1.33 --output Chain_proc2_wait200000_run$PBS_ARRAY_INDEX >> pMCMC2_run$PBS_ARRAY_INDEX.out >> pMCMC2_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 800000 --seed -1 --acceptprob 0.2 --variance 1.33 --output Chain_proc2_wait800000_run$PBS_ARRAY_INDEX >> pMCMC2_run$PBS_ARRAY_INDEX.out >> pMCMC2_run$PBS_ARRAY_INDEX.out
