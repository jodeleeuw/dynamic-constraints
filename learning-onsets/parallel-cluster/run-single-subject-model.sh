#!/bin/bash
#PBS -l nodes=4:ppn=32
#PBS -l walltime=100:00:00
#PBS -q cpu
#PBS -N single-subject

module load pcp/2008

cd /N/u/jodeleeu/BigRed2/learning-onsets/parallel-cluster

aprun -n 98 pcp single-subject-job-list-full.txt
