#!/bin/sh
#PBS -N 03_map_der
#PBS -l nodes=1:ppn=30
#PBS -q workq
#PBS -o /public3/data/heyutong/m6A20230103/03_map_der/03_map_der.out
#PBS -e /public3/data/heyutong/m6A20230103/03_map_der/03_map_der.err

samtools=~/.conda/envs/hyt/bin/samtools
mkdir /public3/data/heyutong/m6A20230103/03_map_der
Output="/public3/data/heyutong/m6A20230103/03_map_der"

source /public/apps/bioinformatics/anaconda3/bin/activate hyt
cat /public3/data/heyutong/m6A20230103/configm | while read id
do
	arr=($id)
	fq1=${arr[0]}
	fq2=${arr[1]}
hisat2 -x /public3/data/heyutong/reference/hisat2index/UCSC_mm10/mm10/genome -p 15 -1 $fq1 -2 $fq2 --summary-file $Output/$(basename $fq1 .derRNA.fq.1.gz).align_summary -S $Output/$(basename $fq1 .derRNA.fq.1.gz).sam
grep -E "^@|NH:i:1" $Output/$(basename $fq1 .derRNA.fq.1.gz).sam  > $Output/$(basename $fq1 .derRNA.fq.1.gz).uniq.sam
$samtools view -@ 8 -bS $Output/$(basename $fq1 .derRNA.fq.1.gz).uniq.sam > $Output/$(basename $fq1 .derRNA.fq.1.gz).uniq.bam
$samtools sort -@ 8 $Output/$(basename $fq1 .derRNA.fq.1.gz).uniq.bam -o $Output/$(basename $fq1 .derRNA.fq.1.gz).uniq.sort.bam
$samtools index -@ 8 -b $Output/$(basename $fq1 .derRNA.fq.1.gz).uniq.sort.bam
done
conda deactivate

