#!/bin/bash
#PBS -l nodes=1:ppn=32
#PBS -l walltime=01:00:00
#PBS -q debug_cpu
#PBS -N empirical-dists

module load pcp/2008

cd /N/u/jodeleeu/BigRed2/learning-onsets/empirical-distributions

aprun -n 31 pcp empirical-dist-job-list.txt
