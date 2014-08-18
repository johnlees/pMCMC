#!/bin/bash

#PBS -V
#PBS -N pMCMC_8
#PBS -l walltime=0:35:00
#PBS -l select=1:ncpus=8:mpiprocs=8
#PBS -m bea
#PBS -M john.lees@balliol.ox.ac.uk

cd $PBS_O_WORKDIR

. enable_hal_mpi.sh

time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 1 --seed -1 --acceptprob 0.1140 --variance 1.69 --output Chain_proc8_wait1_run$PBS_ARRAY_INDEX > pMCMC8_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 500 --seed -1 --acceptprob 0.1140 --variance 1.69 --output Chain_proc8_wait500_run$PBS_ARRAY_INDEX >> pMCMC8_run$PBS_ARRAY_INDEX.out >> pMCMC8_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 1000 --seed -1 --acceptprob 0.1140 --variance 1.69 --output Chain_proc8_wait1000_run$PBS_ARRAY_INDEX >> pMCMC8_run$PBS_ARRAY_INDEX.out >> pMCMC8_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 2000 --seed -1 --acceptprob 0.1140 --variance 1.69 --output Chain_proc8_wait2000_run$PBS_ARRAY_INDEX >> pMCMC8_run$PBS_ARRAY_INDEX.out >> pMCMC8_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 3000 --seed -1 --acceptprob 0.1140 --variance 1.69 --output Chain_proc8_wait3000_run$PBS_ARRAY_INDEX >> pMCMC8_run$PBS_ARRAY_INDEX.out >> pMCMC8_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 5000 --seed -1 --acceptprob 0.1140 --variance 1.69 --output Chain_proc8_wait5000_run$PBS_ARRAY_INDEX >> pMCMC8_run$PBS_ARRAY_INDEX.out >> pMCMC8_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 6000 --seed -1 --acceptprob 0.1140 --variance 1.69 --output Chain_proc8_wait6000_run$PBS_ARRAY_INDEX >> pMCMC8_run$PBS_ARRAY_INDEX.out >> pMCMC8_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 7000 --seed -1 --acceptprob 0.1140 --variance 1.69 --output Chain_proc8_wait7000_run$PBS_ARRAY_INDEX >> pMCMC8_run$PBS_ARRAY_INDEX.out >> pMCMC8_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 8000 --seed -1 --acceptprob 0.1140 --variance 1.69 --output Chain_proc8_wait8000_run$PBS_ARRAY_INDEX >> pMCMC8_run$PBS_ARRAY_INDEX.out >> pMCMC8_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 9000 --seed -1 --acceptprob 0.1140 --variance 1.69 --output Chain_proc8_wait9000_run$PBS_ARRAY_INDEX >> pMCMC8_run$PBS_ARRAY_INDEX.out >> pMCMC8_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 10000 --seed -1 --acceptprob 0.1140 --variance 1.69 --output Chain_proc8_wait10000_run$PBS_ARRAY_INDEX >> pMCMC8_run$PBS_ARRAY_INDEX.out >> pMCMC8_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 15000 --seed -1 --acceptprob 0.1140 --variance 1.69 --output Chain_proc8_wait15000_run$PBS_ARRAY_INDEX >> pMCMC8_run$PBS_ARRAY_INDEX.out >> pMCMC8_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 20000 --seed -1 --acceptprob 0.1140 --variance 1.69 --output Chain_proc8_wait20000_run$PBS_ARRAY_INDEX >> pMCMC8_run$PBS_ARRAY_INDEX.out >> pMCMC8_run$PBS_ARRAY_INDEX.out
