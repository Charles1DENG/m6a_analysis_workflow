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

# --------------- 设置命令行参数 --------------- #
def get_parser():
    parser = argparse.ArgumentParser(
        prog="01_preprocess.py",     # 程序名
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
    parser_trim.add_argument('-j', action="store", required=False, dest="jobs", 
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
    parser_hisat = subparsers.add_parser('mapping', help='run hisat2')
    parser_hisat.set_defaults(subcommand = run_mapping)
    
    parser_hisat.add_argument('--batch', action="store_true", required=False, dest="batch", 
                        help="if set, run as batch mode.")
    parser_hisat.add_argument('-j', action="store", required=False, dest="jobs", 
                        help="Run n jobs in parallel.")
    
    
    
    
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
            with open(f"{working_dir}/parallel.txt", 'a') as f:
                f.write(f"{trim_galore_exe} --quality {args.quality} --fastqc --paired --length 25 \
                --output_dir {args.outdir} {fq1} {fq2} & \n")
                f.close()
        # 提交并行
        os.system(f"{parallel_exe} -j {args.jobs} < {working_dir}/parallel.txt")
        os.system(f"{multiqc_exe} {args.outdir} --outdir {args.outdir}")
    else:
        os.system(f"{trim_galore_exe} --quality {args.quality} --fastqc --paired --length 25 \
            --output_dir {args.outdir} {args.fq1} {args.fq2}")
        
def run_mapping(args):
    # 如果输出路径不存在，创建
    if not os.path.exists(args.outdir):
        os.mkdir(args.outdir)


# 设置if __name__ == "__main__"的作用是：当文件被执行时运行代码，文件被导入时不执行代码
if __name__ == "__main__":
    start_time = time.time()
    
    # 获取输入参数
    args = get_parser()
    args = args.subcommand(args)

    end_time = time.time()
    print("Finished !\n")
    print(f"Time consumption: {float(end_time) - float(start_time):.4f}s")