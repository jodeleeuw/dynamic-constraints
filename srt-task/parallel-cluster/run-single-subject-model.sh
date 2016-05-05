#!/bin/bash
#PBS -l nodes=12:ppn=32
#PBS -l walltime=48:00:00
#PBS -q cpu
#PBS -N srt-single-subject

module load pcp/2008

cd /N/u/jodeleeu/BigRed2/srt-task/parallel-cluster

aprun -n 384 pcp single-subject-job-list-full.txt