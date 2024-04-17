#!/bin/bash
#SBATCH --time=5-00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=m.lisette.delgado@gmail.com
#SBATCH --mem=10000M
#SBATCH --cpus-per-task=15

module load gcc gsl

export PATH=${PATH}:${HOME}/software/ROHan/bin
BASEDIR=~/projects/rrg-ruzza/ldelgado/all_bams/
REFERENCE=~/projects/rrg-ruzza/ldelgado/GadMor3.0_genome/
NAME=$1

rohan --rohmu 2e-3 -o $NAME"_ROH_ALL" $REFERENCE"gadMor3.0.fna" $BASEDIR$NAME"_dedup_overlapclip_realigned.bam"
