#!/bin/sh
#PBS -N 02_rmRNA
#PBS -l nodes=1:ppn=30
#PBS -q workq
#PBS -o /public3/data/heyutong/m6A20230103/02_rmRNA/02_rmRNA.out
#PBS -e /public3/data/heyutong/m6A20230103/02_rmRNA/02_rmRNA.err

#mkdir /public3/data/heyutong/m6A20230103/02_rmRNA/
index=/public3/data/heyutong/m6A20220622/rRNAindex/Mus_musculus.rRNA
output="/public3/data/heyutong/m6A20230103/02_rmRNA"
cat /public3/data/heyutong/m6A20230103/configr | while read id
do 
	arr=($id)
	fq1=${arr[0]}
	fq2=${arr[1]}
bowtie2 -p 8 -x $index --un-conc-gz ${output}/$(basename $fq1 _CleanData_R1_val_1.fq.gz).derRNA.fq.gz -1 $fq1 -2 $fq2 \
-S ${output}/$(basename $fq1 _CleanData_R1_val_1.fq.gz).rRNA.mapped.sam 2> ${output}/$(basename $fq1 _CleanData_R1_val_1.fq.gz).log
done