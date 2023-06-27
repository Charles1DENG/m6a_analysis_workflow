#!/bin/bash
#PBS -N 06_anno_homer_gtf
#PBS -l nodes=1:ppn=30
#PBS -q workq
#PBS -o /public3/data/heyutong/m6A20230103/06_anno_homer_gtf/06_anno_homer_gtf.o
#PBS -e /public3/data/heyutong/m6A20230103/06_anno_homer_gtf/06_anno_homer_gtf.e

mkdir /public3/data/heyutong/m6A20230103/06_anno_homer_gtf/
source /public/apps/bioinformatics/anaconda3/bin/activate hyt

annotatePeaks.pl /public3/data/heyutong/m6A20230103/04_exomePeak_der/Adult_heart_peak/Mod.bed mm10 -gtf /public3/data/heyutong/reference/ucsc/mm10.knownGene.gtf > /public3/data/heyutong/m6A20230103/06_anno_homer_gtf/Adult_heart_anno.txt
annotatePeaks.pl /public3/data/heyutong/m6A20230103/04_exomePeak_der/Fetal_heart_peak/Mod.bed mm10 -gtf /public3/data/heyutong/reference/ucsc/mm10.knownGene.gtf > /public3/data/heyutong/m6A20230103/06_anno_homer_gtf/Fetal_heart_anno.txt
annotatePeaks.pl /public3/data/heyutong/m6A20230103/04_exomePeak_der/R1_peak/Mod.bed mm10 -gtf /public3/data/heyutong/reference/ucsc/mm10.knownGene.gtf > /public3/data/heyutong/m6A20230103/06_anno_homer_gtf/R1_anno.txt

conda deactivate

