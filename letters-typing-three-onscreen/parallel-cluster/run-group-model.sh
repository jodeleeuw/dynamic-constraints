#!/bin/bash
#PBS -l nodes=2:ppn=32
#PBS -l walltime=48:00:00
#PBS -q cpu
#PBS -N group-three-onscreen

module load pcp/2008

cd /N/u/jodeleeu/BigRed2/letters-typing-three-onscreen/parallel-cluster

aprun -n 64 pcp group-model-job-list.txt