#!/bin/bash
#SBATCH --time=3-00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=m.lisette.delgado@gmail.com
#SBATCH --nodes=1
#SBATCH --mem=120G
#SBATCH --cpus-per-task=32


#submit with: sbatch CC_cod_07_GL_op1_global.sh

#run in scratch within the folder you want to save the outputs

#Load modules
module load StdEnv/2020
module load angsd/0.939

BAMFILE=$1
OUTPUT=$2
MINDP=$3
MAXDP=$4
MININD=$5

REF=/project/def-ruzza/ldelgado/GadMor3.0_genome/gadMor3.0.fna

angsd -bam $BAMFILE -ref $REF -out $OUTPUT -P 30 \
-GL 1 -doGlf 2  -doMaf 1 -doMajorMinor 1 -doCounts 1 -doDepth 1 -dumpCounts 1 -doIBS 1 \
-makematrix 1 -doCov 1 -SNP_pval 1e-6 -setMinDepth $MINDP -setMaxDepth $MAXDP \
-minMapQ 20 -minQ 20 -minMaf 0.05 -minInd $MININD \
-uniqueOnly 1 -remove_bads 1 -only_proper_pairs 1 -C 50

## Create a SNP list to use in downstream analyses
gunzip -c $OUTPUT'.mafs.gz' | cut -f 1,2,3,4 | tail -n +2 > $OUTPUT'_snps_list.txt'

angsd sites index $OUTPUT'_snps_list.txt'

## Also make it in regions format for downstream analyses
cut -f 1,2 $OUTPUT'_snps_list.txt' | sed 's/\t/:/g' > $OUTPUT'_snps_list.regions'

## Lastly, extract a list of chromosomes/LGs/scaffolds for downstream analysis
cut -f1 $OUTPUT'_snps_list.txt' | sort | uniq > $OUTPUT'_snps_list.chrs'
