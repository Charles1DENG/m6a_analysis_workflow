#!/bin/sh
#PBS -N 05_motif_homer
#PBS -l nodes=1:ppn=30
#PBS -q workq
#PBS -o /public3/data/heyutong/m6A20230103/05_motif_homer/05_motif_homer.out
#PBS -e /public3/data/heyutong/m6A20230103/05_motif_homer/05_motif_homer.err


mkdir /public3/data/heyutong/m6A20230103/05_motif_homer/Adult_lung_peak/
mkdir /public3/data/heyutong/m6A20230103/05_motif_homer/Fetal_heart_peak/
mkdir /public3/data/heyutong/m6A20230103/05_motif_homer/R1_peak/

source /public/apps/bioinformatics/anaconda3/bin/activate hyt

findMotifsGenome.pl /public3/data/heyutong/m6A20230103/04_exomePeak_der/Adult_heart_peak/Mod.bed mm10 /public3/data/heyutong/m6A20230103/05_motif_homer/Adult_heart_peak/ -size 200 -p 15 -S 10 -len 5,7,9
findMotifsGenome.pl /public3/data/heyutong/m6A20230103/04_exomePeak_der/Fetal_heart_peak/Mod.bed mm10 /public3/data/heyutong/m6A20230103/05_motif_homer/Fetal_heart_peak/ -size 200 -p 15 -S 10 -len 5,7,9
findMotifsGenome.pl /public3/data/heyutong/m6A20230103/04_exomePeak_der/R1_peak/Mod.bed mm10 /public3/data/heyutong/m6A20230103/05_motif_homer/R1_peak/ -size 200 -p 15 -S 10 -len 5,7,9

conda deactivate
