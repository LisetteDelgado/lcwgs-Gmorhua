#!/bin/bash
#SBATCH --time=5-00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=m.lisette.delgado@gmail.com
#SBATCH --nodes=1
#SBATCH --mem=120G
#SBATCH --cpus-per-task=32


#run in scratch within the folder you want to save the outputs

#Load modules
module load StdEnv/2020 angsd/0.939

#REALSFS=$EBROOTANGSD/bin/realSFS
#THETASTAT=$EBROOTANGSD/bin/thetaStat

BAMFILES=$1
SNPLIST=$2
CHRMLIST=$3
OUT=$4

angsd sites index $2

angsd -nThreads 30 -doHWE 1 -GL 1 -minMapQ 20 -minQ 20 -remove_bads 1 -doMajorMinor 3 \
-b $BAMFILES -sites $SNPLIST -rf $CHRMLIST -out $OUT  


#$REALSFS $POP'.saf.idx' -P 30 -fold 1 > $POP'.folded.sfs'
#$REALSFS saf2theta  $POP'.saf.idx' -sfs $POP'.folded.sfs' -outname $POP -fold 1
#$THETASTAT do_stat $POP'.thetas.idx' -win 10000 -step 1000 -outnames $POP'.thetas.windows.gz'
