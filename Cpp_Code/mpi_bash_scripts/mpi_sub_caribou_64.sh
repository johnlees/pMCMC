#!/bin/bash

#PBS -V
#PBS -N pMCMC_64
#PBS -l walltime=0:35:00
#PBS -l nodes=8:ncpus=64
#PBS -m bea
#PBS -M john.lees@balliol.ox.ac.uk

cd $PBS_O_WORKDIR

. ./enable_hal_mpi.sh

time mpirun -np 64 ./parallel_trees --master 1 --iterations 4000 --waiting 1 --seed -1 --acceptprob 0.028 --variance 2.75 --output Chain_proc64_wait1_run$PBS_ARRAY_INDEX > pMCMC64_run$PBS_ARRAY_INDEX.out
time mpirun -np 64 ./parallel_trees --master 1 --iterations 4000 --waiting 500 --seed -1 --acceptprob 0.028 --variance 2.75 --output Chain_proc64_wait500_run$PBS_ARRAY_INDEX >> pMCMC64_run$PBS_ARRAY_INDEX.out >> pMCMC64_run$PBS_ARRAY_INDEX.out
time mpirun -np 64 ./parallel_trees --master 1 --iterations 4000 --waiting 1000 --seed -1 --acceptprob 0.028 --variance 2.75 --output Chain_proc64_wait1000_run$PBS_ARRAY_INDEX >> pMCMC64_run$PBS_ARRAY_INDEX.out >> pMCMC64_run$PBS_ARRAY_INDEX.out
time mpirun -np 64 ./parallel_trees --master 1 --iterations 4000 --waiting 2000 --seed -1 --acceptprob 0.028 --variance 2.75 --output Chain_proc64_wait2000_run$PBS_ARRAY_INDEX >> pMCMC64_run$PBS_ARRAY_INDEX.out >> pMCMC64_run$PBS_ARRAY_INDEX.out
time mpirun -np 64 ./parallel_trees --master 1 --iterations 4000 --waiting 3000 --seed -1 --acceptprob 0.028 --variance 2.75 --output Chain_proc64_wait3000_run$PBS_ARRAY_INDEX >> pMCMC64_run$PBS_ARRAY_INDEX.out >> pMCMC64_run$PBS_ARRAY_INDEX.out
time mpirun -np 64 ./parallel_trees --master 1 --iterations 4000 --waiting 5000 --seed -1 --acceptprob 0.028 --variance 2.75 --output Chain_proc64_wait5000_run$PBS_ARRAY_INDEX >> pMCMC64_run$PBS_ARRAY_INDEX.out >> pMCMC64_run$PBS_ARRAY_INDEX.out
time mpirun -np 64 ./parallel_trees --master 1 --iterations 4000 --waiting 6000 --seed -1 --acceptprob 0.028 --variance 2.75 --output Chain_proc64_wait6000_run$PBS_ARRAY_INDEX >> pMCMC64_run$PBS_ARRAY_INDEX.out >> pMCMC64_run$PBS_ARRAY_INDEX.out
time mpirun -np 64 ./parallel_trees --master 1 --iterations 4000 --waiting 7000 --seed -1 --acceptprob 0.028 --variance 2.75 --output Chain_proc64_wait7000_run$PBS_ARRAY_INDEX >> pMCMC64_run$PBS_ARRAY_INDEX.out >> pMCMC64_run$PBS_ARRAY_INDEX.out
time mpirun -np 64 ./parallel_trees --master 1 --iterations 4000 --waiting 8000 --seed -1 --acceptprob 0.028 --variance 2.75 --output Chain_proc64_wait8000_run$PBS_ARRAY_INDEX >> pMCMC64_run$PBS_ARRAY_INDEX.out >> pMCMC64_run$PBS_ARRAY_INDEX.out
time mpirun -np 64 ./parallel_trees --master 1 --iterations 4000 --waiting 9000 --seed -1 --acceptprob 0.028 --variance 2.75 --output Chain_proc64_wait9000_run$PBS_ARRAY_INDEX >> pMCMC64_run$PBS_ARRAY_INDEX.out >> pMCMC64_run$PBS_ARRAY_INDEX.out
time mpirun -np 64 ./parallel_trees --master 1 --iterations 4000 --waiting 10000 --seed -1 --acceptprob 0.028 --variance 2.75 --output Chain_proc64_wait10000_run$PBS_ARRAY_INDEX >> pMCMC64_run$PBS_ARRAY_INDEX.out >> pMCMC64_run$PBS_ARRAY_INDEX.out
time mpirun -np 64 ./parallel_trees --master 1 --iterations 4000 --waiting 15000 --seed -1 --acceptprob 0.028 --variance 2.75 --output Chain_proc64_wait15000_run$PBS_ARRAY_INDEX >> pMCMC64_run$PBS_ARRAY_INDEX.out >> pMCMC64_run$PBS_ARRAY_INDEX.out
time mpirun -np 64 ./parallel_trees --master 1 --iterations 4000 --waiting 20000 --seed -1 --acceptprob 0.028 --variance 2.75 --output Chain_proc64_wait20000_run$PBS_ARRAY_INDEX >> pMCMC64_run$PBS_ARRAY_INDEX.out >> pMCMC64_run$PBS_ARRAY_INDEX.out
time mpirun -np 64 ./parallel_trees --master 1 --iterations 4000 --waiting 800000 --seed -1 --acceptprob 0.028 --variance 2.75 --output Chain_proc64_wait800000_run$PBS_ARRAY_INDEX >> pMCMC64_run$PBS_ARRAY_INDEX.out >> pMCMC64_run$PBS_ARRAY_INDEX.out
