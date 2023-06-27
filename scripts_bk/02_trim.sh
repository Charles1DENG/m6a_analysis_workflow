#!/bin/sh
#PBS -N 02_trim
#PBS -l nodes=1:ppn=30
#PBS -q workq
#PBS -o /public3/data/heyutong/m6A20230103/02_trim/02_trim.out
#PBS -e /public3/data/heyutong/m6A20230103/02_trim/02_trim.err

##PE
mkdir /public3/data/heyutong/m6A20230103/02_trim/
dir="/public3/data/heyutong/m6A20230103/02_trim/"

source /public/apps/bioinformatics/anaconda3/bin/activate trimgalore
cat /public3/data/heyutong/m6A20230103/configt | while read id
do
       arr=(${id})
       fq1=${arr[0]}
       fq2=${arr[1]}  
/public/home/heyutong/.conda/envs/trimgalore/bin/trim_galore -q 25 --phred33 --illumina --fastqc --stringency 3 --paired --gzip --cores 10 -o $dir $fq1 $fq2 2> $dir/$(basename $fq1 _R1.fastq.gz)_trim.log
done
conda deactivate
