#!/bin/bash

#PBS -V
#PBS -N pMCMC_16
#PBS -l walltime=0:35:00
#PBS -l select=2:ncpus=8:mpiprocs=8
#PBS -m bea
#PBS -M john.lees@balliol.ox.ac.uk

cd $PBS_O_WORKDIR

. enable_hal_mpi.sh

time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 1 --seed -1 --acceptprob 0.0760 --variance 2.01 --output Chain_proc16_wait1_run$PBS_ARRAY_INDEX > pMCMC16_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 500 --seed -1 --acceptprob 0.0760 --variance 2.01 --output Chain_proc16_wait500_run$PBS_ARRAY_INDEX >> pMCMC16_run$PBS_ARRAY_INDEX.out >> pMCMC16_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 1000 --seed -1 --acceptprob 0.0760 --variance 2.01 --output Chain_proc16_wait1000_run$PBS_ARRAY_INDEX >> pMCMC16_run$PBS_ARRAY_INDEX.out >> pMCMC16_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 2000 --seed -1 --acceptprob 0.0760 --variance 2.01 --output Chain_proc16_wait2000_run$PBS_ARRAY_INDEX >> pMCMC16_run$PBS_ARRAY_INDEX.out >> pMCMC16_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 3000 --seed -1 --acceptprob 0.0760 --variance 2.01 --output Chain_proc16_wait3000_run$PBS_ARRAY_INDEX >> pMCMC16_run$PBS_ARRAY_INDEX.out >> pMCMC16_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 5000 --seed -1 --acceptprob 0.0760 --variance 2.01 --output Chain_proc16_wait5000_run$PBS_ARRAY_INDEX >> pMCMC16_run$PBS_ARRAY_INDEX.out >> pMCMC16_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 6000 --seed -1 --acceptprob 0.0760 --variance 2.01 --output Chain_proc16_wait6000_run$PBS_ARRAY_INDEX >> pMCMC16_run$PBS_ARRAY_INDEX.out >> pMCMC16_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 7000 --seed -1 --acceptprob 0.0760 --variance 2.01 --output Chain_proc16_wait7000_run$PBS_ARRAY_INDEX >> pMCMC16_run$PBS_ARRAY_INDEX.out >> pMCMC16_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 8000 --seed -1 --acceptprob 0.0760 --variance 2.01 --output Chain_proc16_wait8000_run$PBS_ARRAY_INDEX >> pMCMC16_run$PBS_ARRAY_INDEX.out >> pMCMC16_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 9000 --seed -1 --acceptprob 0.0760 --variance 2.01 --output Chain_proc16_wait9000_run$PBS_ARRAY_INDEX >> pMCMC16_run$PBS_ARRAY_INDEX.out >> pMCMC16_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 10000 --seed -1 --acceptprob 0.0760 --variance 2.01 --output Chain_proc16_wait10000_run$PBS_ARRAY_INDEX >> pMCMC16_run$PBS_ARRAY_INDEX.out >> pMCMC16_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 15000 --seed -1 --acceptprob 0.0760 --variance 2.01 --output Chain_proc16_wait15000_run$PBS_ARRAY_INDEX >> pMCMC16_run$PBS_ARRAY_INDEX.out >> pMCMC16_run$PBS_ARRAY_INDEX.out
time mpirun $MPI_HOSTS ./parallel_trees --master 1 --iterations 4000 --waiting 20000 --seed -1 --acceptprob 0.0760 --variance 2.01 --output Chain_proc16_wait20000_run$PBS_ARRAY_INDEX >> pMCMC16_run$PBS_ARRAY_INDEX.out >> pMCMC16_run$PBS_ARRAY_INDEX.out
