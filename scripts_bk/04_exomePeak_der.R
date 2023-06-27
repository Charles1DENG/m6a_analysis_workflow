library(exomePeak2)
setwd("/public3/data/heyutong/m6A20230103/03_map_der")
#gtf <- "/public3/data/heyutong/reference/gencode/grcm38_M25/gencode.vM25.primary_assembly.annotation.gtf"
gtf <- "/public3/data/heyutong/reference/ucsc/mm10.knownGene.gtf"

IP_bam <- c("A1_heart_IP.uniq.sort.bam","A2_heart_IP.uniq.sort.bam")
INPUT_bam <- c("A1_heart_input.uniq.sort.bam","A2_heart_input.uniq.sort.bam")
Adult_heart_peak <- exomePeak2(gff_dir =gtf,bam_ip = IP_bam,bam_input = INPUT_bam,
                               genome = "mm10",paired_end = T,parallel = 10,
                               save_dir = "/public3/data/heyutong/m6A20230103/04_exomePeak_der/Adult_heart_peak")

IP_bam <- c("E22_heart_IP.uniq.sort.bam","E27_heart_IP.uniq.sort.bam")
INPUT_bam <- c("E22_heart_input.uniq.sort.bam","E27_heart_input.uniq.sort.bam")
Adult_heart_peak <- exomePeak2(gff_dir =gtf,bam_ip = IP_bam,bam_input = INPUT_bam,
                               genome = "mm10",paired_end = T,parallel = 10,
                               save_dir = "/public3/data/heyutong/m6A20230103/04_exomePeak_der/Fetal_heart_peak")

IP_bam <- c("R1_1101_IP.uniq.sort.bam","R1_925_IP.uniq.sort.bam")
INPUT_bam <- c("R1_1101_input.uniq.sort.bam","R1_925_input.uniq.sort.bam")
Adult_heart_peak <- exomePeak2(gff_dir =gtf,bam_ip = IP_bam,bam_input = INPUT_bam,
                               genome = "mm10",paired_end = T,parallel = 10,
                               save_dir = "/public3/data/heyutong/m6A20230103/04_exomePeak_der/R1_peak")
