#!/bin/bash
#SBATCH --time=1-00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=m.lisette.delgado@gmail.com
#SBATCH --nodes=1
#SBATCH --mem=120G
#SBATCH --cpus-per-task=32


#run in scratch within the folder you want to save the outputs

#Load modules
module load gcc gsl

INPUT=$1
IND=$2
SITES=$3
DIST=$4
OUTPUT=$5


ngsLD --geno $INPUT'.beagle.gz' --posH $INPUT'.pos.gz' --probs --rnd_sample 1 --n_ind $IND \
--n_sites $SITES --max_kb_dist $DIST --n_threads 30 --out $OUTPUT'.ld'
