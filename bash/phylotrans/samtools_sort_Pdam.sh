#!/bin/bash
#BSUB -J sort_pdam
#BSUB -q general
#BSUB -P transcriptomics
#BSUB -o sort_pdam%J.out
#BSUB -e sort_pdam%J.err
#BSUB -n 8
#BSUB -u m.connelly1@umiami.edu

#~/scripts/EAPSI.HW-WT-master/samtools_sort_Pdam.sh
#/scratch/projects/transcriptomics/mikeconnelly/scripts/EAPSI.HW-WT-master/samtools_sort_Pdam.sh
#purpose: sort bam files by coordinate for downstream SNP processing

#specify variable containing sequence file prefixes and directory paths
mcs="/scratch/projects/transcriptomics/mikeconnelly"
coldir="/scratch/projects/transcriptomics/mikeconnelly/sequences/EAPSI/houwanwanglitung"
exp="alltreatments"
EAPSIsamples="Hw1-6a Hw1-6b Hw1-6c Hw2-6b Hw2-6c Wt1-6a Wt1-6b Wt1-6c Wt2-6a Wt2-6b Wt2-6c"

#lets me know which files are being processed
echo "These are the bam files to be processed : $EAPSIsamples"

#sort output bam files
for EAPSIsample in $EAPSIsamples
do \
samtools sort \
${coldir}/${exp}/STARalign_Pdam/${EAPSIsample}_PdamAligned.out.bam \
> ${coldir}/${exp}/STARalign_Pdam/${EAPSIsample}_PdamAligned.sorted.out.bam
done

#index sorted bam files
for EAPSIsample in $EAPSIsamples
do \
samtools index -b \
${coldir}/${exp}/STARalign_Pdam/${EAPSIsample}_PdamAligned.sorted.out.bam
done

#need to install samtools
#${mcs}/programs/samtools-1.9/
