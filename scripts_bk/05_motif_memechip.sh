#!/bin/bash
#PBS -N 05_motif_memechip
#PBS -l nodes=1:ppn=30
#PBS -q workq
#PBS -o /public3/data/heyutong/m6A20230103/05_motif_memechip/05_motif_memechip.o
#PBS -e /public3/data/heyutong/m6A20230103/05_motif_memechip/05_motif_memechip.e

Output="/public3/data/heyutong/m6A20230103/05_motif_memechip/"
source /public/apps/bioinformatics/anaconda3/bin/activate hyt

ls /public3/data/heyutong/m6A20230103/05_motif_memechip/*bed | while read id
do
#fastaFromBed -fi /public3/data/heyutong/reference/gatkindex_hg19/hg19.fa -bed $id -fo $Output/$(basename $id .bed).fa
#mkdir $Output/$(basename $id .bed)
meme-chip $Output/$(basename $id .bed).fa -dna -oc $Output/$(basename $id .bed) -meme-mod zoops -meme-nmotifs 3 -meme-minw 4 -meme-maxw 6 2> $Output/$(basename $id .bed)/memechip.log
done

conda deactivate
