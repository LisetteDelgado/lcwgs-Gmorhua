#!/bin/bash
#SBATCH --time=9-00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=m.lisette.delgado@gmail.com
#SBATCH --nodes=1
#SBATCH --mem=120G
#SBATCH --cpus-per-task=32

#make sure you run bowtie2-build to the reference genome to create indexes
#submit with: sbatch CC_cod_03_map.sh

#run in scratch within the folder you want to save the outputs

#Load modules
module load StdEnv/2020 gcc/9.3.0
module load bowtie2/2.4.4
module load samtools/1.13

BASEDIR=/home/ldelgado/scratch/may2021_fastp_relax
File="samplesnames.txt"
Lines=$(cat $File)

for name in $Lines

do 

bowtie2 -q --phred33 -p 30 --very-sensitive --rg-id "$name" --rg SM:"$name" --rg LB:"$name" -x /project/def-ruzza/ldelgado/GadMor3.0_genome/gadMor3.0 -1 $BASEDIR/"$name"_R1_paired_trimmed.fastq.gz -2 $BASEDIR/"$name"_R2_paired_trimmed.fastq.gz -S "$name".sam

#convert to bam
samtools view -bS -F 4 -@ 30 "$name".sam > "$name".bam
rm -f "$name".sam

#filter mapped reads
samtools view -h -q 20 "$name".bam | samtools view -@ 30 -buS | samtools sort -@ 30 -o "$name"_sorted.bam

done |& tee -a map.log
