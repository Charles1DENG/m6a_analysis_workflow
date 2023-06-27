#!/bin/bash
#PBS -N 01_QC
#PBS -l nodes=1:ppn=30
#PBS -q workq
#PBS -o /public3/data/heyutong/m6A20230103/01_QC/01_QC.out
#PBS -e /public3/data/heyutong/m6A20230103/01_QC/01_QC.err

mkdir /public3/data/heyutong/m6A20230103/01_QC
output="/public3/data/heyutong/m6A20230103/01_QC"
cat /public3/data/heyutong/m6A20230103/CleanData/config | while read id
do
fastqc $id -t 10 -o $output/ 2>$output/$(basename $id .fastq.gz)_fastqc.log
done
