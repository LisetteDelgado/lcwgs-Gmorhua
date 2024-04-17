#!/bin/bash
#SBATCH --time=1-00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=m.lisette.delgado@gmail.com
#SBATCH --nodes=1
#SBATCH --mem=120G
#SBATCH --cpus-per-task=32


#submit with: sbatch CC_cod_06_depth.sh

#run in scratch within the folder you want to save the outputs

#Load modules
module load StdEnv/2020 gcc/9.3.0
module load samtools/1.13

BAMLIST=/home/ldelgado/scratch/imputation_realigned/samplesnames.txt

# loop over each sample
for SAMPLEBAM in `cat $BAMLIST`; do

	samtools depth -aa $SAMPLEBAM'_dedup_overlapclip_realigned.bam' | cut -f 3 | gzip > $SAMPLEBAM'.depth.gz' 

done

