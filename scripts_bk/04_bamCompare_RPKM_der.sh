#!/bin/sh
#PBS -N 04_bamCompare_RPKM_der
#PBS -l nodes=1:ppn=30
#PBS -q workq
#PBS -o /public3/data/heyutong/m6A20230103/04_bamCompare_RPKM_der/04_bamCompare_RPKM_der.out
#PBS -e /public3/data/heyutong/m6A20230103/04_bamCompare_RPKM_der/04_bamCompare_RPKM_der.err

mkdir /public3/data/heyutong/m6A20230103/04_bamCompare_RPKM_der
Output="/public3/data/heyutong/m6A20230103/04_bamCompare_RPKM_der"

source /public/apps/bioinformatics/anaconda3/bin/activate hyt
cat /public3/data/heyutong/m6A20230103/configc_derRNA | while read id
do
        arr=(${id})
        IP=${arr[0]}
        Input=${arr[1]}
        name=${arr[2]}
~/.conda/envs/hyt/bin/bamCompare -b1 $IP -b2 $Input -o $Output/${name}.bw --scaleFactorsMethod None --normalizeUsing RPKM --operation log2 -p 20 --binSize 20 2>$Output/${name}.log
conda deactivate
done
