#!/bin/bash
#SBATCH --time=2-00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=m.lisette.delgado@gmail.com
#SBATCH --nodes=1
#SBATCH --mem=30G
#SBATCH --cpus-per-task=4

#run in scratch within the folder you want to save the outputs

#Load modules
module load StdEnv/2023
module load angsd/0.940


PHENOFILE=$1
BAMFILES=$2
OUT=$3

angsd -yBin $PHENOFILE -doAsso 1 -GL 1 -out $OUT -doMajorMinor 1 \
-doMaf 1 -SNP_pval 1e-6 -bam $BAMFILES -P 4
