#!/bin/bash

#PBS -V
#PBS -N pMCMC_2
#PBS -l walltime=0:58:59
#PBS -l select=1:ncpus=2:mpiprocs=2
#PBS -m bea
#PBS -M john.lees@balliol.ox.ac.uk

cd $PBS_O_WORKDIR

. enable_hal_mpi.sh

time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 1 --seed -1 --acceptprob 0.2 --variance 1.33 --output Chain_proc2_wait1_run$PBS_ARRAY_INDEX > pMCMC2_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 500 --seed -1 --acceptprob 0.2 --variance 1.33 --output Chain_proc2_wait500_run$PBS_ARRAY_INDEX >> pMCMC2_run$PBS_ARRAY_INDEX.out >> pMCMC2_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 1000 --seed -1 --acceptprob 0.2 --variance 1.33 --output Chain_proc2_wait1000_run$PBS_ARRAY_INDEX >> pMCMC2_run$PBS_ARRAY_INDEX.out >> pMCMC2_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 2000 --seed -1 --acceptprob 0.2 --variance 1.33 --output Chain_proc2_wait2000_run$PBS_ARRAY_INDEX >> pMCMC2_run$PBS_ARRAY_INDEX.out >> pMCMC2_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 3000 --seed -1 --acceptprob 0.2 --variance 1.33 --output Chain_proc2_wait3000_run$PBS_ARRAY_INDEX >> pMCMC2_run$PBS_ARRAY_INDEX.out >> pMCMC2_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 5000 --seed -1 --acceptprob 0.2 --variance 1.33 --output Chain_proc2_wait5000_run$PBS_ARRAY_INDEX >> pMCMC2_run$PBS_ARRAY_INDEX.out >> pMCMC2_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 6000 --seed -1 --acceptprob 0.2 --variance 1.33 --output Chain_proc2_wait6000_run$PBS_ARRAY_INDEX >> pMCMC2_run$PBS_ARRAY_INDEX.out >> pMCMC2_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 7000 --seed -1 --acceptprob 0.2 --variance 1.33 --output Chain_proc2_wait7000_run$PBS_ARRAY_INDEX >> pMCMC2_run$PBS_ARRAY_INDEX.out >> pMCMC2_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 8000 --seed -1 --acceptprob 0.2 --variance 1.33 --output Chain_proc2_wait8000_run$PBS_ARRAY_INDEX >> pMCMC2_run$PBS_ARRAY_INDEX.out >> pMCMC2_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 9000 --seed -1 --acceptprob 0.2 --variance 1.33 --output Chain_proc2_wait9000_run$PBS_ARRAY_INDEX >> pMCMC2_run$PBS_ARRAY_INDEX.out >> pMCMC2_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 10000 --seed -1 --acceptprob 0.2 --variance 1.33 --output Chain_proc2_wait10000_run$PBS_ARRAY_INDEX >> pMCMC2_run$PBS_ARRAY_INDEX.out >> pMCMC2_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 15000 --seed -1 --acceptprob 0.2 --variance 1.33 --output Chain_proc2_wait15000_run$PBS_ARRAY_INDEX >> pMCMC2_run$PBS_ARRAY_INDEX.out >> pMCMC2_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 20000 --seed -1 --acceptprob 0.2 --variance 1.33 --output Chain_proc2_wait20000_run$PBS_ARRAY_INDEX >> pMCMC2_run$PBS_ARRAY_INDEX.out >> pMCMC2_run$PBS_ARRAY_INDEX.out
