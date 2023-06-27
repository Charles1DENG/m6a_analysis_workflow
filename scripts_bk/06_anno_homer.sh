#!/bin/bash
#PBS -N 06_anno_homer
#PBS -l nodes=1:ppn=30
#PBS -q workq
#PBS -o /public3/data/heyutong/m6A20230103/06_anno_homer/06_anno_homer.o
#PBS -e /public3/data/heyutong/m6A20230103/06_anno_homer/06_anno_homer.e

source /public/apps/bioinformatics/anaconda3/bin/activate hyt

annotatePeaks.pl /public3/data/heyutong/m6A20230103/04_exomePeak_der/Adult_heart_peak/Mod.bed mm10 > /public3/data/heyutong/m6A20230103/06_anno_homer/Adult_heart_anno.txt
annotatePeaks.pl /public3/data/heyutong/m6A20230103/04_exomePeak_der/Fetal_heart_peak/Mod.bed mm10 > /public3/data/heyutong/m6A20230103/06_anno_homer/Fetal_heart_anno.txt
annotatePeaks.pl /public3/data/heyutong/m6A20230103/04_exomePeak_der/R1_peak/Mod.bed mm10 > /public3/data/heyutong/m6A20230103/06_anno_homer/R1_anno.txt

conda deactivate

