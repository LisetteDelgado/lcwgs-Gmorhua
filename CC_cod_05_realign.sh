#!/bin/bash
#SBATCH --time=10-00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=m.lisette.delgado@gmail.com
#SBATCH --nodes=1
#SBATCH --mem=120G
#SBATCH --cpus-per-task=32


#submit with: sbatch CC_cod_05_realign.sh

#run in scratch within the folder you want to save the outputs

#Load modules
module load StdEnv/2020 gcc/9.3.0
#module load samtools/1.13
module load nixpkgs/16.09 gatk/3.7
module load java/1.8.0_121

module list
which java

#_dedup_overclip.bam files
BAMLIST=/home/ldelgado/scratch/sept2022_realigned/overlapclip_bam_list_path.list
BASEDIR=/home/ldelgado/scratch/sept2022_realigned/
#JOB_INDEX=0

#First get the index for each bam with samtools

# loop over each sample
#for SAMPLEBAM in `cat $BAMLIST`; do

#if [ -e $SAMPLEBAM'.bai' ]; then
#	echo "the file already exists"
#else
	## Index bam files
#	samtools index $SAMPLEBAM &

#	JOB_INDEX=$(( JOB_INDEX + 1 ))
#	if [ $JOB_INDEX == 1 ]; then
#		wait
#		JOB_INDEX=0
#	fi
#fi

#done

#create list of potential indels
if [ ! -f $BASEDIR'all_samples_for_indel_realigner.intervals' ]; then
	java -Xmx120G -jar "${EBROOTGATK}"/GenomeAnalysisTK.jar -T RealignerTargetCreator \
	-R /project/def-ruzza/ldelgado/GadMor3.0_genome/gadMor3.0.fna \
	-I $BAMLIST -o $BASEDIR'all_samples_for_indel_realigner.intervals' -drf BadMate

fi 

#Run the indel realigner tool
java -Xmx120G -jar "${EBROOTGATK}"/GenomeAnalysisTK.jar -T IndelRealigner \
 -R /project/def-ruzza/ldelgado/GadMor3.0_genome/gadMor3.0.fna \
 -I $BAMLIST -targetIntervals $BASEDIR'all_samples_for_indel_realigner.intervals'\
 --consensusDeterminationModel USE_READS --nWayOut _realigned.bam

