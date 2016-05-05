#!/bin/bash
#PBS -l nodes=1:ppn=32
#PBS -l walltime=08:00:00
#PBS -q cpu
#PBS -N individual-three-onscreen

cd /N/u/jodeleeu/BigRed2/letters-typing-three-onscreen/parallel-cluster

aprun -n 32 Rscript run-jags-individual-model-parallel.R