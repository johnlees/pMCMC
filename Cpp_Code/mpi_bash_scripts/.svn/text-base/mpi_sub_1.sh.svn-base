#!/bin/bash

#PBS -V
#PBS -N pMCMC_1
#PBS -l walltime=0:80:00
#PBS -l select=1:ncpus=1:mpiprocs=1
#PBS -m bea
#PBS -M john.lees@balliol.ox.ac.uk

cd $PBS_O_WORKDIR

. enable_hal_mpi.sh

./serial --master 1 --iterations 4000 --waiting 1 --seed -1 --acceptprob 0.2338 --variance 1.2 --output Chain_proc1_wait1_run$PBS_ARRAY_INDEX > pMCMC1_run$PBS_ARRAY_INDEX.out
./serial --master 1 --iterations 4000 --waiting 500 --seed -1 --acceptprob 0.2338 --variance 1.2 --output Chain_proc1_wait500_run$PBS_ARRAY_INDEX >> pMCMC1_run$PBS_ARRAY_INDEX.out >> pMCMC1_run$PBS_ARRAY_INDEX.out
./serial --master 1 --iterations 4000 --waiting 1000 --seed -1 --acceptprob 0.2338 --variance 1.2 --output Chain_proc1_wait1000_run$PBS_ARRAY_INDEX >> pMCMC1_run$PBS_ARRAY_INDEX.out >> pMCMC1_run$PBS_ARRAY_INDEX.out
./serial --master 1 --iterations 4000 --waiting 2000 --seed -1 --acceptprob 0.2338 --variance 1.2 --output Chain_proc1_wait2000_run$PBS_ARRAY_INDEX >> pMCMC1_run$PBS_ARRAY_INDEX.out >> pMCMC1_run$PBS_ARRAY_INDEX.out
./serial --master 1 --iterations 4000 --waiting 3000 --seed -1 --acceptprob 0.2338 --variance 1.2 --output Chain_proc1_wait3000_run$PBS_ARRAY_INDEX >> pMCMC1_run$PBS_ARRAY_INDEX.out >> pMCMC1_run$PBS_ARRAY_INDEX.out
./serial --master 1 --iterations 4000 --waiting 5000 --seed -1 --acceptprob 0.2338 --variance 1.2 --output Chain_proc1_wait5000_run$PBS_ARRAY_INDEX >> pMCMC1_run$PBS_ARRAY_INDEX.out >> pMCMC1_run$PBS_ARRAY_INDEX.out
./serial --master 1 --iterations 4000 --waiting 6000 --seed -1 --acceptprob 0.2338 --variance 1.2 --output Chain_proc1_wait6000_run$PBS_ARRAY_INDEX >> pMCMC1_run$PBS_ARRAY_INDEX.out >> pMCMC1_run$PBS_ARRAY_INDEX.out
./serial --master 1 --iterations 4000 --waiting 7000 --seed -1 --acceptprob 0.2338 --variance 1.2 --output Chain_proc1_wait7000_run$PBS_ARRAY_INDEX >> pMCMC1_run$PBS_ARRAY_INDEX.out >> pMCMC1_run$PBS_ARRAY_INDEX.out
./serial --master 1 --iterations 4000 --waiting 8000 --seed -1 --acceptprob 0.2338 --variance 1.2 --output Chain_proc1_wait8000_run$PBS_ARRAY_INDEX >> pMCMC1_run$PBS_ARRAY_INDEX.out >> pMCMC1_run$PBS_ARRAY_INDEX.out
./serial --master 1 --iterations 4000 --waiting 9000 --seed -1 --acceptprob 0.2338 --variance 1.2 --output Chain_proc1_wait9000_run$PBS_ARRAY_INDEX >> pMCMC1_run$PBS_ARRAY_INDEX.out >> pMCMC1_run$PBS_ARRAY_INDEX.out
./serial --master 1 --iterations 4000 --waiting 10000 --seed -1 --acceptprob 0.2338 --variance 1.2 --output Chain_proc1_wait10000_run$PBS_ARRAY_INDEX >> pMCMC1_run$PBS_ARRAY_INDEX.out >> pMCMC1_run$PBS_ARRAY_INDEX.out
./serial --master 1 --iterations 4000 --waiting 15000 --seed -1 --acceptprob 0.2338 --variance 1.2 --output Chain_proc1_wait15000_run$PBS_ARRAY_INDEX >> pMCMC1_run$PBS_ARRAY_INDEX.out >> pMCMC1_run$PBS_ARRAY_INDEX.out
./serial --master 1 --iterations 4000 --waiting 20000 --seed -1 --acceptprob 0.2338 --variance 1.2 --output Chain_proc1_wait20000_run$PBS_ARRAY_INDEX >> pMCMC1_run$PBS_ARRAY_INDEX.out >> pMCMC1_run$PBS_ARRAY_INDEX.out
