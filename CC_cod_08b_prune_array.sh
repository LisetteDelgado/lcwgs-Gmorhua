#!/bin/bash

#SBATCH --time=1-00:00
#SBATCH --job-name=ld_pruning
#SBATCH --mail-type=ALL
#SBATCH --mail-user=m.lisette.delgado@gmail.com
#SBATCH --nodes=1
#SBATCH --array=1-23
#SBATCH --ntasks=1
#SBATCH --mem=4000M
#SBATCH --tmp=120G

## Define some variables
INPUT_PATH=/home/ldelgado/scratch/ld_contemporary/
LD=$1
MAXDIST=20 
MINWEIGHT=0.5
PRUNE_GRAPH=/home/ldelgado/scratch/scripts/prune_graph.pl
LG_LIST=/home/ldelgado/scratch/ld_contemporary/chromosomes_list.txt


##################################################

## Keep a record of the Job ID
echo $SLURM_JOB_ID
## Create and move to working directory for job
WORKDIR=${SLURM_TMPDIR}/
cd $WORKDIR
## Transfer the input files
cp $INPUT_PATH$LD $WORKDIR
## Select the LG from the input file
LG=`head $LG_LIST -n $SLURM_ARRAY_TASK_ID | tail -n 1`
grep ^${LG}: $WORKDIR$LD > $WORKDIR${LD%%.*}_${LG}.ld
## Define the output name
OUT=${LD%%.*}_unlinked_${LG}.id
## Run the perl script
perl $PRUNE_GRAPH \
--in_file $WORKDIR${LD%%.*}_${LG}.ld \
--max_kb_dist $MAXDIST \
--min_weight $MINWEIGHT \
--out $WORKDIR$OUT
## Move output files back
cp $WORKDIR$OUT $INPUT_PATH

