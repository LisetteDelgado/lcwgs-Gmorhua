#!/bin/bash
#SBATCH --time=2-00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=m.lisette.delgado@gmail.com
#SBATCH --nodes=1
#SBATCH --mem=120G
#SBATCH --cpus-per-task=32

# Make sure the adapter.fa file in in the directory where running the script
# Sequences of adapters used for cod:
	# >transposase1
	# GCCTCCCTCGCGCCATCAGAGATGTGTATAAGAGACAG
	# >transposase1_rc
	# CTGTCTCTTATACACATCTCTGATGGCGCGAGGGAGGC
	# >transposase2
	# GCCTTGCCAGCCCGCTCAGAGATGTGTATAAGAGACAG
	# >transposase2_rc
	# CTGTCTCTTATACACATCTCTGAGCGGGCTGGCAAGGC
    # >PrefixPE/1
    # TACACTCTTTCCCTACACGACGCTCTTCCGATCT
    # >PrefixPE/2
    # GTGACTGGAGTTCAGACGTGTGCTCTTCCGATCT
    # >PE1
    # TACACTCTTTCCCTACACGACGCTCTTCCGATCT
    # >PE1_rc
    # AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTA
    # >PE2
    # GTGACTGGAGTTCAGACGTGTGCTCTTCCGATCT
    # >PE2_rc
    # AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC

#submit with: sbatch CC_cod_02_trim.sh

#run in scratch within the folder you want to save the outputs

#Load modules
module load StdEnv/2020
module load trimmomatic/0.39

BASEDIR=~/scratch/imputation_raw/
File="samplesnames_rest.txt"
Lines=$(cat $File)

for name in $Lines

do 

    java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.39.jar PE -threads 23 $BASEDIR/"$name"_R1.fastq.gz $BASEDIR/"$name"_R2.fastq.gz "$name"_R1_paired.fastq.gz "$name"_R1_unpaired.fastq.gz "$name"_R2_paired.fastq.gz "$name"_R2_unpaired.fastq.gz ILLUMINACLIP:adapters.fa:2:30:10:2:true  MINLEN:40

done |& tee -a trim.log
