#!/bin/bash

#PBS -V
#PBS -N MPI_bench_2
#PBS -l walltime=0:10:00
#PBS -l select=1:ncpus=8:mpiprocs=8
#PBS -m bea
#PBS -M john.lees@balliol.ox.ac.uk

cd /data/stat-compbio-summer-school/cbss0001/mpi

. ./enable_hal_mpi.sh

cat $MPI_HOSTS > $PWD/mpd.hosts

mpirun -np 8 IMB-MPI1 Sendrecv Bcast PingPong
