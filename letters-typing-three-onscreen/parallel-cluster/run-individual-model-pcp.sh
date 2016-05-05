#!/bin/bash
#PBS -l nodes=4:ppn=32
#PBS -l walltime=48:00:00
#PBS -q cpu
#PBS -N individual-three-onscreen-pcp

module load pcp/2008

cd /N/u/jodeleeu/BigRed2/letters-typing-three-onscreen/parallel-cluster

aprun -n 128 pcp individual-model-job-list-full.txt