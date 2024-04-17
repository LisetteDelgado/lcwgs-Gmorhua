#!/bin/bash
#SBATCH --time=3-00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=m.lisette.delgado@gmail.com
#SBATCH --nodes=1
#SBATCH --mem=120G
#SBATCH --cpus-per-task=32


#run in scratch within the folder you want to save the outputs

#Load modules
module load StdEnv/2020
module load angsd/0.939

REF=/project/def-ruzza/ldelgado/GadMor3.0_genome/gadMor3.0.fna
BAMFILES=$1
SNPLIST=$2
OUT=$3


angsd sites index $SNPLIST

angsd -bam $BAMFILES -anc $REF -out $OUT -P 30 -sites $SNPLIST \
-GL 1 -doGlf 2 -doMajorMinor 3 -doMAF 1 -doPost 1 -doIBS 1 -doCounts 1 -doCov 1 -makeMatrix 1 
