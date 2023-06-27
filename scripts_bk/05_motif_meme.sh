#!/bin/bash
#PBS -N 05_motif_meme
#PBS -l nodes=1:ppn=30
#PBS -q workq
#PBS -o /public3/data/heyutong/m6A20230103/05_motif_meme/05_motif_meme.o
#PBS -e /public3/data/heyutong/m6A20230103/05_motif_meme/05_motif_meme.e

Output="/public3/data/heyutong/m6A20230103/05_motif_meme/"
source /public/apps/bioinformatics/anaconda3/bin/activate hyt

ls /public3/data/heyutong/m6A20230103/05_motif_meme/*bed | while read id
do
fastaFromBed -fi /public3/data/heyutong/reference/ucsc/mm10/mm10_chromFaMasked/mm10_maskedChroms_onlychr.fa -bed $id -fo $Output/$(basename $id .bed).fa
mkdir $Output/$(basename $id .bed)
meme $Output/$(basename $id .bed).fa -dna -oc $Output/$(basename $id .bed) -mod zoops -nmotifs 5 -minw 4 -maxw 6 2> $Output/$(basename $id .bed)/memechip.log
done

conda deactivate
