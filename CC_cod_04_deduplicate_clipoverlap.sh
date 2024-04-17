#!/bin/bash
#SBATCH --time=2-00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=m.lisette.delgado@gmail.com
#SBATCH --nodes=1
#SBATCH --mem=120G
#SBATCH --cpus-per-task=32

#make sure you run picard CreateSequenceDictionary first
#submit with: sbatch CC_cod_04_deduplicate_clipoverlap.sh

#run in scratch within the folder you want to save the outputs

#Load modules
module load StdEnv/2020
module load nixpkgs/16.09  intel/2018.3
module load picard/2.23.2
module load bamutil/1.0.14

File="samplesnames_a.txt"
Lines=$(cat $File)

for name in $Lines

do 

#markduplicates
java -jar $EBROOTPICARD/picard.jar MarkDuplicates I=/home/ldelgado/scratch/may2021_mapped_relax/"$name"_sorted.bam O="$name"_dedup.bam M="$name"_dupstat.txt VALIDATION_STRINGENCY=SILENT REMOVE_DUPLICATES=true

#clip overlapping sequences
bam clipOverlap --in "$name"_dedup.bam --out "$name"_dedup_overlapclip.bam --stats

done |& tee -a deduplicate_clipoverlap.log
