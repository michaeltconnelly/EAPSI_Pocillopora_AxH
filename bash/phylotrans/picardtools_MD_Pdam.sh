#!/bin/bash
#BSUB -J picard_MD_pdam
#BSUB -q general
#BSUB -P transcriptomics
#BSUB -o picard_MD_pdam%J.out
#BSUB -e picard_MD_pdam%J.err
#BSUB -n 8
#BSUB -u m.connelly1@umiami.edu

#~/scripts/EAPSI.HW-WT-master/picardtools_MD_Pdam.sh
#/scratch/projects/transcriptomics/mikeconnelly/scripts/EAPSI.HW-WT-master/picardtools_MD_Pdam.sh
#purpose: sort bam files by coordinate for downstream SNP processing

#specify variable containing sequence file prefixes and directory paths
mcs="/scratch/projects/transcriptomics/mikeconnelly"
coldir="/scratch/projects/transcriptomics/mikeconnelly/sequences/EAPSI/houwanwanglitung"
exp="alltreatments"
EAPSIsamples="Hw1-6a Hw1-6b Hw1-6c Hw2-6b Hw2-6c Wt1-6a Wt1-6b Wt1-6c Wt2-6a Wt2-6b Wt2-6c"

#lets me know which files are being processed
echo "These are the bam files to be processed : $EAPSIsamples"

module load java/1.8.0_60
module load picard-tools/1.103

for EAPSIsample in $EAPSIsamples
do \
java -jar /share/apps/picard-tools/1.103/AddOrReplaceReadGroups.jar \
INPUT=${coldir}/${exp}/STARalign_Pdam/${EAPSIsample}_PdamAligned.sorted.out.bam \
OUTPUT=${coldir}/${exp}/STARalign_Pdam/${EAPSIsample}_PdamAligned.sorted.out.rg.bam \
RGID=id \
RGLB=library \
RGPL=illumina \
RGPU=unit1 \
RGSM=${EAPSIsample}

java -jar /share/apps/picard-tools/1.103/MarkDuplicates.jar \
INPUT= ${coldir}/${exp}/STARalign_Pdam/${EAPSIsample}_PdamAligned.sorted.out.rg.bam \
OUTPUT=${coldir}/${exp}/STARalign_Pdam/${EAPSIsample}_PdamAligned.sorted.out.md.rg.bam \
CREATE_INDEX=true \
VALIDATION_STRINGENCY=SILENT \
METRICS_FILE=${coldir}/${exp}/STARalign_Pdam/${EAPSIsample}_marked_dup_metrics.txt
done
