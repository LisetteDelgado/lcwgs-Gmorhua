#!/bin/bash
#SBATCH --time=08:00:00
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

POPLIST=$1
MINDP=$2
MAXDP=$3
MININD=$4
SNPLIST=$5
CHRLIST=$6

angsd sites index $5

for POP in $(cat $POPLIST)
do
	echo $POP
	angsd -b $POP.files -ref $REF -anc $REF -out $POP -P 30 \
	-GL 1 -doSaf 1 -doMajorMinor 3 -doMaf 1 -doCounts 1 -doDepth 1 -dumpCounts 1 \
	-setMinDepth $MINDP -setMaxDepth $MAXDP -minInd $MININD -minQ 20 -minMapQ 20 \
	-uniqueOnly 1 -remove_bads 1 -only_proper_pairs 1 -trim 0 -C 50 \
	-sites $SNPLIST -rf $CHRLIST 
done
