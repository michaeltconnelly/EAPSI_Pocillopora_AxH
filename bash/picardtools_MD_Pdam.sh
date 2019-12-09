#!/bin/bash
#./bash/picardtools_MD_Pdam.sh
#purpose: sort bam files by coordinate for downstream SNP processing
#To start this job from the EAPSI_Pocillopora_AxH directory, use:
#bsub -P transcriptomics < ./bash/picardtools_MD_Pdam.sh

#BSUB -J picard_MD_pdam
#BSUB -q general
#BSUB -P transcriptomics
#BSUB -o picard_MD_pdam%J.out
#BSUB -e picard_MD_pdam%J.err
#BSUB -n 8
#BSUB -u m.connelly1@umiami.edu

#specify variable containing sequence file prefixes and directory paths
mcs="/scratch/projects/transcriptomics/mikeconnelly"
prodir="/scratch/projects/transcriptomics/mikeconnelly/projects/EAPSI_Pocillopora_AxH"
exp="AxH"
EAPSIsamples="Wt1-1a Wt1-1b Wt1-1c Wt1-4a Wt1-4b Wt1-4c Wt1-5a Wt1-5b Wt1-5c Wt1-6a Wt1-6b Wt1-6c Wt2-1a Wt2-1b Wt2-1c Wt2-4a Wt2-4b Wt2-4c Wt2-5a Wt2-5b Wt2-5c Wt2-6a Wt2-6b Wt2-6c Hw1-1a Hw1-1b Hw1-1c Hw1-4a Hw1-4b Hw1-4c Hw1-5a Hw1-5b Hw1-5c Hw1-6a Hw1-6b Hw1-6c Hw2-1a Hw2-1b Hw2-1c Hw2-4a Hw2-4b Hw2-4c Hw2-5a Hw2-5b Hw2-5c Hw2-6b Hw2-6c"

#lets me know which files are being processed
echo "These are the bam files to be processed : $EAPSIsamples"

module load java/1.8.0_60
module load picard-tools/1.103

for EAPSIsample in $EAPSIsamples
do \
java -jar /share/apps/picard-tools/1.103/AddOrReplaceReadGroups.jar \
INPUT=${prodir}/outputs/phylotrans_Pdam/${EAPSIsample}_PdamAligned.sorted.out.bam \
OUTPUT=${prodir}/outputs/phylotrans_Pdam/${EAPSIsample}_PdamAligned.sorted.out.rg.bam \
RGID=id \
RGLB=library \
RGPL=illumina \
RGPU=unit1 \
RGSM=${EAPSIsample}

java -jar /share/apps/picard-tools/1.103/MarkDuplicates.jar \
INPUT= ${prodir}/outputs/phylotrans_Pdam/${EAPSIsample}_PdamAligned.sorted.out.rg.bam \
OUTPUT=${prodir}/outputs/phylotrans_Pdam/${EAPSIsample}_PdamAligned.sorted.out.md.rg.bam \
CREATE_INDEX=true \
VALIDATION_STRINGENCY=SILENT \
METRICS_FILE=${prodir}/outputs/phylotrans_Pdam/${EAPSIsample}_marked_dup_metrics.txt
done

bsub -P transcriptomics < ./bash/gatk_splitN_Pdam.sh
echo "Started next job in phylotranscriptomics pipeline: GATK SplitNCigarReads"
