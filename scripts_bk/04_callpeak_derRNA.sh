#!/bin/sh
#PBS -N 04_callpeak_derRNA
#PBS -l nodes=1:ppn=30
#PBS -q workq
#PBS -o /public3/data/heyutong/m6A20230103/04_callpeak_derRNA/04_callpeak_derRNA.out
#PBS -e /public3/data/heyutong/m6A20230103/04_callpeak_derRNA/04_callpeak_derRNA.err


mkdir /public3/data/heyutong/m6A20230103/04_callpeak_derRNA
Output="/public3/data/heyutong/m6A20230103/04_callpeak_derRNA"

source /public/apps/bioinformatics/anaconda3/bin/activate hyt
cat /public3/data/heyutong/m6A20230103/configc_derRNA | while read id

do
        arr=(${id})
        IP=${arr[0]}
        Input=${arr[1]}
        name=${arr[2]}
/public/home/heyutong/.conda/envs/hyt/bin/macs2 callpeak --nomodel -t $IP -c $Input -n $name  -g mm --keep-dup all --extsize 200 -B --format BAM --outdir $Output/ 2>$Output/${name}_macs2.log
done
conda deactivate
