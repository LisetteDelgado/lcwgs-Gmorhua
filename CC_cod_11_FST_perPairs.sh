#!/bin/bash
#SBATCH --time=06:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=m.lisette.delgado@gmail.com
#SBATCH --nodes=1
#SBATCH --mem=120G
#SBATCH --cpus-per-task=32


#run in scratch within the folder you want to save the outputs

#Load modules
module load StdEnv/2020 angsd/0.939

REALSFS=$EBROOTANGSD/bin/realSFS

#compute overall folded SFS

POP1=$1
POP2=$2

for POP in $POP1 $POP2
do
	echo $POP
	$REALSFS $POP'.saf.idx' -fold 1 > $POP'.folded.sfs'
done

#Do the 2dSFS for pairwise comparisons
$REALSFS $POP1'.saf.idx' $POP2'.saf.idx' -P 30 -fold 1 > $POP1'_'$POP2'.folded.sfs'

#start Fst estimation
$REALSFS fst index $POP1'.saf.idx' $POP2'.saf.idx' -sfs $POP1'_'$POP2'.folded.sfs' \
-fstout $POP1'_'$POP2'.folded.pbs' -whichFst 1

#convert fst from binary to txt
$REALSFS fst print $POP1'_'$POP2'.folded.pbs.fst.idx' > $POP1'_'$POP2'_Fst_list.txt'

#sliding window
$REALSFS fst stats2 $POP1'_'$POP2'.folded.pbs.fst.idx' -win 1000 -step 100 > $POP1'_'$POP2'_folded.win1000step100.pbs.fst.txt'
