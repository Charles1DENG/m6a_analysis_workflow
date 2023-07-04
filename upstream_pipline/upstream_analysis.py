#!/home/charles/softwares/miniconda3/bin python
# -*- coding: utf-8 -*-
# @Author  :    CharlesDeng
# @Project :    m6a_data

import os, argparse, time
from distutils.spawn import find_executable

# 设置默认全局变量
working_dir = os.path.dirname(os.path.abspath(__file__))
fastqc_exe = str(find_executable("/home/charles/softwares/FastQC/fastqc"))
multiqc_exe = str(find_executable("/home/charles/softwares/miniconda3/bin/multiqc"))
trim_galore_exe = str(find_executable("/home/charles/softwares/TrimGalore-0.6.10/trim_galore"))
parallel_exe = str(find_executable("/usr/bin/parallel"))
samtools_exe = str(find_executable("/home/charles/softwares/miniconda3/bin/samtools"))
hisat2_exe = str(find_executable("/home/charles/softwares/hisat2-2.2.1/hisat2"))

# 设置参考index
mm10_hisat2 = "/home/charles/Projects/genomicData/Hisat2_index/mm10/genome"

# --------------- 设置命令行参数 --------------- #
def get_parser():
    parser = argparse.ArgumentParser(
        prog="upstream_analysis.py",     # 程序名
        description="NGS raw data preprocess"   # 脚本描述说明
    )
    
    subparsers = parser.add_subparsers(title="Functions", required=True, metavar="")
    
    # step1：fastqc
    parser_fastqc = subparsers.add_parser('fastqc', help='run fastqc')
    parser_fastqc.set_defaults(subcommand = run_fastqc)

    parser_fastqc.add_argument('--batch', action="store_true", required=False, dest="batch", 
                            help="if set, run as batch mode.")  # store_true：如果指定了--batch参数，则参数值设置为true
    parser_fastqc.add_argument('-fq', action="store", type=str, dest="fq", required=False,
                            help="fastq file path (batch mode).")
    parser_fastqc.add_argument('-fq1', action="store", type=str, dest="fq1",
                            help="fastq R1 file path.")
    parser_fastqc.add_argument('-fq2', action="store", type=str, dest="fq2", default=None,
                            help="fastq R2 file path.")
    parser_fastqc.add_argument('-o', '--outdir', action="store", type=str, dest="outdir",
                            help="output directory of fastqc results.", 
                            default=f"{working_dir}/../fastqc_out")
    
    # step2：trim
    parser_trim = subparsers.add_parser('trim', help='run trim_galore')
    parser_trim.set_defaults(subcommand = run_trim)
    
    parser_trim.add_argument('--batch', action="store_true", required=False, dest="batch", 
                        help="if set, run as batch mode.")
    parser_trim.add_argument('-j', action="store", required=False, dest="jobs", default=4, 
                        help="Run n jobs in parallel.")
    parser_trim.add_argument('-q', "--quality", action="store", type=str, dest="quality", 
                            required=False, default=20,
                            help="quality threshold (default 20).")
    parser_trim.add_argument('-fq', action="store", type=str, dest="fq", required=False,
                            help="fastq file path (batch mode).")
    parser_trim.add_argument('-fq1', action="store", type=str, dest="fq1",
                            help="fastq R1 file path.")
    parser_trim.add_argument('-fq2', action="store", type=str, dest="fq2",
                            help="fastq R2 file path.")
    parser_trim.add_argument('-o', '--outdir', action="store", type=str, dest="outdir",
                            help="output directory of trim_galore results.", 
                            default=f"{working_dir}/../trim_out")
    
    # step3: mapping (hisat2)
    parser_hisat = subparsers.add_parser('hisat2', help='run hisat2')
    parser_hisat.set_defaults(subcommand = run_hisat2)
    
    parser_hisat.add_argument('--batch', action="store_true", required=False, dest="batch", 
                        help="if set, run as batch mode.")
    parser_hisat.add_argument('-j', action="store", required=False, dest="jobs", 
                        help="Run n jobs in parallel.")
    parser_hisat.add_argument('-x', action="store", required=False, dest="index", default=mm10_hisat2,
                        help="hisat2 index with path (default: /home/charles/Projects/genomicData/Hisat2_index/mm10/genome).")
    parser_hisat.add_argument('-fq', action="store", required=False, dest="fq", 
                        help="fastq file directory (use --batch).")
    parser_hisat.add_argument('-1', action="store", required=False, dest="fq1", 
                        help="fastq Read1 file.")
    parser_hisat.add_argument('-2', action="store", required=False, dest="fq2", 
                        help="fastq Read2 file.")
    parser_hisat.add_argument('-S', action="store", required=False, dest="prefix", 
                        help="output filename in sam format.")
    parser_hisat.add_argument('-o', '--outdir', action="store", required=False, dest="outdir",
                            help="output directory of hisat2 results.", 
                            default=f"{working_dir}/../align_out")
    
    return parser.parse_args()

def run_fastqc(args):
    # 如果输出路径不存在，创建
    if not os.path.exists(args.outdir):
        os.mkdir(args.outdir)

    if args.batch:
        fq_files = [f"{args.fq}/{file}" for file in os.listdir(args.fq)]
        input_fastq = " ".join(fq_files)
    else:
        input_fastq = f"{args.fastq1} {args.fastq2}"
        
    os.system(f"{fastqc_exe} -f fastq --noextract -o {args.outdir} {input_fastq}")
    os.system(f"{multiqc_exe} {args.outdir} --outdir {args.outdir}")
    
def run_trim(args):
    # 如果输出路径不存在，创建
    if not os.path.exists(args.outdir):
        os.mkdir(args.outdir)
    
    if args.batch:
        fq1_files = [f"{args.fq}/{file}" for file in os.listdir(args.fq) if file.endswith("R1.fastq.gz")]
        fq1_files.sort()
        fq2_files = [f"{args.fq}/{file}" for file in os.listdir(args.fq) if file.endswith("R2.fastq.gz")]
        fq2_files.sort()
        
        for fq1, fq2 in zip(fq1_files, fq2_files):
            with open(f"{working_dir}/parallel_trim.txt", 'a') as f:
                f.write(f"{trim_galore_exe} --quality {args.quality} --fastqc --paired --length 25 \
                --output_dir {args.outdir} {fq1} {fq2} & \n")
                f.close()
        # 提交并行
        os.system(f"{parallel_exe} -j {args.jobs} < {working_dir}/parallel.txt")
        os.system(f"{multiqc_exe} {args.outdir} --outdir {args.outdir}")
    else:
        os.system(f"{trim_galore_exe} --quality {args.quality} --fastqc --paired --length 25 \
            --output_dir {args.outdir} {args.fq1} {args.fq2}")
        
def run_hisat2(args):
    # 如果输出路径不存在，创建
    if not os.path.exists(args.outdir):
        os.mkdir(args.outdir)
        
    if args.batch:
        fq1_files = [f"{args.fq}/{file}" for file in os.listdir(args.fq) if file.endswith("_1.fq.gz")]
        fq1_files.sort()
        fq2_files = [f"{args.fq}/{file}" for file in os.listdir(args.fq) if file.endswith("_2.fq.gz")]
        fq2_files.sort()
        
        for fq1, fq2 in zip(fq1_files, fq2_files):
            sam_prefix = fq1.split("/")[-1].split("_CleanData_R1_val_1.fq.gz")[0]
            with open(f"{working_dir}/parallel_hisat2.txt", 'a') as f:
                f.write(f"nohup {hisat2_exe} -x {args.index} -1 {fq1} -2 {fq2} -S {args.outdir}/{sam_prefix}.sam > \
                    /home/charles/Projects/m6a_data/logout/03_hisat2_{sam_prefix}.out 2>&1 & \n")
                f.close()
        os.system(f"{parallel_exe} -j {args.jobs} < {working_dir}/parallel_hisat2.txt")

    else:
        os.system(f"{hisat2_exe} -x {args.index} -1 {args.fq1} -2 {args.fq2} -S {args.outdir}/{args.prefix}.sam")
        '''
        samtools view -@ 8 -b R1_925_IP.sam > R1_925_IP.bam &
        samtools sort -@ 8 R1_925_IP.bam -o R1_925_IP.sorted.bam &
        samtools index -@ 8 R1_925_IP.sorted.bam R1_925_IP.sorted.bai &
        
        samtools view -@ 8 -b R1_925_input.sam > R1_925_input.bam &
        samtools sort -@ 8 R1_925_input.bam -o R1_925_input.sorted.bam &
        samtools index -@ 8 R1_925_input.sorted.bam R1_925_input.sorted.bai &
        '''
        
        #os.system(f"{samtools_exe} view -@ {args.jobs} -b {args.outdir}/{args.prefix}.sam > {args.outdir}/{args.prefix}.bam")
        #os.system(f"{samtools_exe} sort -@ {args.jobs} {args.outdir}/{args.prefix}.bam -o {args.outdir}/{args.prefix}.sorted.bam")
        #os.system(f"{samtools_exe} index -@ {args.jobs} {args.outdir}/{args.prefix}.sorted.bam {args.outdir}/{args.prefix}.sorted.bai")
        #os.system(f"rm {args.outdir}/{args.prefix}.bam")

# 设置if __name__ == "__main__"的作用是：当文件被执行时运行代码，文件被导入 时不执行代码
if __name__ == "__main__":
    start_time = time.time()
    
    # 获取输入参数
    args = get_parser()
    args = args.subcommand(args)

    end_time = time.time()
    print("Finished !\n")
    print(f"Time consumption: {float(end_time) - float(start_time):.4f}s")