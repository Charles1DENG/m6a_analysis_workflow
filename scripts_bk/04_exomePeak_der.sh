#!/bin/sh
#PBS -N 04_exomePeak_der
#PBS -l nodes=1:ppn=20
#PBS -q workq
#PBS -o /public3/data/heyutong/m6A20230103/04_exomePeak_der/exomepeak.out
#PBS -e /public3/data/heyutong/m6A20230103/04_exomePeak_der/exomepeak.err

mkdir /public3/data/heyutong/m6A20230103/04_exomePeak_der/
source /public/apps/bioinformatics/anaconda3/bin/activate R

Rscript /public3/data/heyutong/m6A20230103/04_exomePeak_der.R > /public3/data/heyutong/m6A20230103/04_exomePeak_der/exomepeak.log

conda deactivate
