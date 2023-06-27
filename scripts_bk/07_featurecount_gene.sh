#!/bin/bash
#PBS -N 07_featurecount_gene
#PBS -l nodes=1:ppn=20
#PBS -q workq
#PBS -o /public3/data/heyutong/m6A20230103/07_featurecount_gene/07_featurecount_gene.o
#PBS -e /public3/data/heyutong/m6A20230103/07_featurecount_gene/07_featurecount_gene.e

mkdir /public3/data/heyutong/m6A20230103/07_featurecount_gene/
indir=/public3/data/heyutong/tools/subread-2.0.3-Linux-x86_64/bin
Output="/public3/data/heyutong/m6A20230103/07_featurecount_gene/"
gtf=/public3/data/heyutong/reference/gencode/grcm38_M25/gencode.vM25.primary_assembly.annotation.gtf

cd /public3/data/heyutong/m6A20230103/03_map_der/
${indir}/featureCounts -T 10 -a $gtf -o ${Output}/Adult_heart.count.txt -t gene -g gene_id -p -B A1_heart_IP.uniq.sort.bam A1_heart_input.uniq.sort.bam A2_heart_IP.uniq.sort.bam A2_heart_input.uniq.sort.bam 2>${Output}/Adult_heart.countlog 
${indir}/featureCounts -T 10 -a $gtf -o ${Output}/Fetal_heart.count.txt -t gene -g gene_id -p -B E22_heart_IP.uniq.sort.bam E22_heart_input.uniq.sort.bam E27_heart_IP.uniq.sort.bam E27_heart_input.uniq.sort.bam 2>${Output}/Fetal_heart.countlog
${indir}/featureCounts -T 10 -a $gtf -o ${Output}/R1.count.txt -t gene -g gene_id -p -B R1_1101_IP.uniq.sort.bam R1_1101_input.uniq.sort.bam R1_925_IP.uniq.sort.bam R1_925_input.uniq.sort.bam 2>${Output}/R1.countlog

