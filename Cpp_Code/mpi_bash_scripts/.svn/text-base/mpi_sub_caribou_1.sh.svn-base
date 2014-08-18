#!/bin/bash

#PBS -V
#PBS -N pMCMC_1
#PBS -l walltime=0:50:00
#PBS -l select=1:ncpus=1
#PBS -m bea
#PBS -M john.lees@balliol.ox.ac.uk

cd $PBS_O_WORKDIR

. ./enable_hal_mpi.sh

./serial --master 1 --iterations 4000 --waiting 200000 --seed -1 --acceptprob 0 --variance 100 --output Chain_proc1_accept0_run$PBS_ARRAY_INDEX > pMCMC1_run$PBS_ARRAY_INDEX.out
./serial --master 1 --iterations 4000 --waiting 200000 --seed -1 --acceptprob 0.02 --variance 3 --output Chain_proc1_wait0.02_run$PBS_ARRAY_INDEX >> pMCMC1_run$PBS_ARRAY_INDEX.out >> pMCMC1_run$PBS_ARRAY_INDEX.out
./serial --master 1 --iterations 4000 --waiting 200000 --seed -1 --acceptprob 0.04 --variance 2.5 --output Chain_proc1_wait0.04_run$PBS_ARRAY_INDEX >> pMCMC1_run$PBS_ARRAY_INDEX.out >> pMCMC1_run$PBS_ARRAY_INDEX.out
./serial --master 1 --iterations 4000 --waiting 200000 --seed -1 --acceptprob 0.05 --variance 2.32 --output Chain_proc1_wait0.05_run$PBS_ARRAY_INDEX >> pMCMC1_run$PBS_ARRAY_INDEX.out >> pMCMC1_run$PBS_ARRAY_INDEX.out
./serial --master 1 --iterations 4000 --waiting 200000 --seed -1 --acceptprob 0.07 --variance 2.07 --output Chain_proc1_wait0.07_run$PBS_ARRAY_INDEX >> pMCMC1_run$PBS_ARRAY_INDEX.out >> pMCMC1_run$PBS_ARRAY_INDEX.out
./serial --master 1 --iterations 4000 --waiting 200000 --seed -1 --acceptprob 0.09 --variance 1.89 --output Chain_proc1_wait0.09_run$PBS_ARRAY_INDEX >> pMCMC1_run$PBS_ARRAY_INDEX.out >> pMCMC1_run$PBS_ARRAY_INDEX.out
./serial --master 1 --iterations 4000 --waiting 200000 --seed -1 --acceptprob 0.1 --variance 1.8 --output Chain_proc1_wait0.1_run$PBS_ARRAY_INDEX >> pMCMC1_run$PBS_ARRAY_INDEX.out >> pMCMC1_run$PBS_ARRAY_INDEX.out
./serial --master 1 --iterations 4000 --waiting 200000 --seed -1 --acceptprob 0.11 --variance 1.74 --output Chain_proc1_wait0.11_run$PBS_ARRAY_INDEX >> pMCMC1_run$PBS_ARRAY_INDEX.out >> pMCMC1_run$PBS_ARRAY_INDEX.out
./serial --master 1 --iterations 4000 --waiting 200000 --seed -1 --acceptprob 0.13 --variance 1.624 --output Chain_proc1_wait0.13_run$PBS_ARRAY_INDEX >> pMCMC1_run$PBS_ARRAY_INDEX.out >> pMCMC1_run$PBS_ARRAY_INDEX.out
./serial --master 1 --iterations 4000 --waiting 200000 --seed -1 --acceptprob 0.15 --variance 1.53 --output Chain_proc1_wait0.15_run$PBS_ARRAY_INDEX >> pMCMC1_run$PBS_ARRAY_INDEX.out >> pMCMC1_run$PBS_ARRAY_INDEX.out
./serial --master 1 --iterations 4000 --waiting 200000 --seed -1 --acceptprob 0.17 --variance 1.43 --output Chain_proc1_wait0.17_run$PBS_ARRAY_INDEX >> pMCMC1_run$PBS_ARRAY_INDEX.out >> pMCMC1_run$PBS_ARRAY_INDEX.out
./serial --master 1 --iterations 4000 --waiting 200000 --seed -1 --acceptprob 0.19 --variance 1.36 --output Chain_proc1_wait0.19_run$PBS_ARRAY_INDEX >> pMCMC1_run$PBS_ARRAY_INDEX.out >> pMCMC1_run$PBS_ARRAY_INDEX.out
./serial --master 1 --iterations 4000 --waiting 200000 --seed -1 --acceptprob 0.2 --variance 1.325 --output Chain_proc1_wait0.2_run$PBS_ARRAY_INDEX >> pMCMC1_run$PBS_ARRAY_INDEX.out >> pMCMC1_run$PBS_ARRAY_INDEX.out
./serial --master 1 --iterations 4000 --waiting 200000 --seed -1 --acceptprob 0.21 --variance 1.29 --output Chain_proc1_wait0.21_run$PBS_ARRAY_INDEX >> pMCMC1_run$PBS_ARRAY_INDEX.out >> pMCMC1_run$PBS_ARRAY_INDEX.out
./serial --master 1 --iterations 4000 --waiting 200000 --seed -1 --acceptprob 0.22 --variance 1.259 --output Chain_proc1_wait0.22_run$PBS_ARRAY_INDEX >> pMCMC1_run$PBS_ARRAY_INDEX.out >> pMCMC1_run$PBS_ARRAY_INDEX.out
./serial --master 1 --iterations 4000 --waiting 200000 --seed -1 --acceptprob 0.23 --variance 1.22 --output Chain_proc1_wait0.23_run$PBS_ARRAY_INDEX >> pMCMC1_run$PBS_ARRAY_INDEX.out >> pMCMC1_run$PBS_ARRAY_INDEX.out
./serial --master 1 --iterations 4000 --waiting 200000 --seed -1 --acceptprob 0.24 --variance 1.195 --output Chain_proc1_wait0.24_run$PBS_ARRAY_INDEX >> pMCMC1_run$PBS_ARRAY_INDEX.out >> pMCMC1_run$PBS_ARRAY_INDEX.out
./serial --master 1 --iterations 4000 --waiting 200000 --seed -1 --acceptprob 0.25 --variance 1.165 --output Chain_proc1_wait0.25_run$PBS_ARRAY_INDEX >> pMCMC1_run$PBS_ARRAY_INDEX.out >> pMCMC1_run$PBS_ARRAY_INDEX.out
./serial --master 1 --iterations 4000 --waiting 200000 --seed -1 --acceptprob 0.26 --variance 1.135 --output Chain_proc1_wait0.26_run$PBS_ARRAY_INDEX >> pMCMC1_run$PBS_ARRAY_INDEX.out >> pMCMC1_run$PBS_ARRAY_INDEX.out
./serial --master 1 --iterations 4000 --waiting 200000 --seed -1 --acceptprob 0.27 --variance 1.109 --output Chain_proc1_wait0.27_run$PBS_ARRAY_INDEX >> pMCMC1_run$PBS_ARRAY_INDEX.out >> pMCMC1_run$PBS_ARRAY_INDEX.out
./serial --master 1 --iterations 4000 --waiting 200000 --seed -1 --acceptprob 0.3 --variance 1.03 --output Chain_proc1_wait0.3_run$PBS_ARRAY_INDEX >> pMCMC1_run$PBS_ARRAY_INDEX.out >> pMCMC1_run$PBS_ARRAY_INDEX.out
./serial --master 1 --iterations 4000 --waiting 200000 --seed -1 --acceptprob 0.35 --variance 0.92 --output Chain_proc1_wait0.35_run$PBS_ARRAY_INDEX >> pMCMC1_run$PBS_ARRAY_INDEX.out >> pMCMC1_run$PBS_ARRAY_INDEX.out
./serial --master 1 --iterations 4000 --waiting 200000 --seed -1 --acceptprob 0.4 --variance 0.82 --output Chain_proc1_wait0.4_run$PBS_ARRAY_INDEX >> pMCMC1_run$PBS_ARRAY_INDEX.out >> pMCMC1_run$PBS_ARRAY_INDEX.out
