#!/bin/bash
#SBATCH --time=1-00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=m.lisette.delgado@gmail.com
#SBATCH --nodes=1
#SBATCH --mem=120G
#SBATCH --cpus-per-task=32

#submit with: sbatch CC_cod_02_polyG.sh

#run in scratch within the folder you want to save the outputs

#Load modules
module load StdEnv/2020
module load fastp/0.23.1

BASEDIR=~/scratch/imputation_raw
File="samplesnames.txt"
Lines=$(cat $File)

for name in $Lines

do 

    fastp --in1 $BASEDIR/"$name"_R1_paired.fastq.gz --in2 $BASEDIR/"$name"_R2_paired.fastq.gz --out1 "$name"_R1_paired_trimmed.fastq.gz --out2 "$name"_R2_paired_trimmed.fastq.gz  \
--cut_right --cut_right_window_size 4 --cut_right_mean_quality 20  \
--trim_poly_g -L -A --poly_g_min_len 10 --thread 30 -h "$name"_fastp.html;

done |& tee -a fastp.log
