#!/bin/bash
#BSUB -J gatk_splitN_pdam
#BSUB -q bigmem
#BSUB -P transcriptomics
#BSUB -o gatk_splitN_pdam%J.out
#BSUB -e gatk_splitN_pdam%J.err
#BSUB -n 8
#BSUB -u m.connelly1@umiami.edu

#~/scripts/EAPSI.HW-WT-master/gatk_splitN_Pdam.sh
#/scratch/projects/transcriptomics/mikeconnelly/scripts/EAPSI.HW-WT-master/gatk_splitN_Pdam.sh
#purpose: SplitNCigarReads preprocessing for bam files

#specify variable containing sequence file prefixes and directory paths
mcs="/scratch/projects/transcriptomics/mikeconnelly"
coldir="/scratch/projects/transcriptomics/mikeconnelly/sequences/EAPSI/houwanwanglitung"
exp="alltreatments"
EAPSIsamples="Hw1-6a Hw1-6b Hw1-6c Hw2-6b Hw2-6c Wt1-6a Wt1-6b Wt1-6c Wt2-6a Wt2-6b Wt2-6c"

#module load samtools/1.3
#module load java/1.8.0_60
#export _JAVA_OPTIONS="-Xmx2g"
#module load GATK/3.4.0

#lets me know which files are being processed
echo "These are the bam files to be processed : $EAPSIsamples"
#--filter_reads_with_N_cigar
for EAPSIsample in $EAPSIsamples
do \
java \
-jar /share/apps/GATK/3.4.0/GenomeAnalysisTK.jar \
-T SplitNCigarReads \
-I ${coldir}/${exp}/STARalign_Pdam/${EAPSIsample}_PdamAligned.sorted.out.md.rg.bam \
-o ${coldir}/${exp}/STARalign_Pdam/${EAPSIsample}_PdamAligned.sorted.out.md.rg.splitN.bam \
-R ${mcs}/sequences/genomes/coral/pocillopora/pdam_genome.fasta \
-rf ReassignOneMappingQuality \
-RMQF 255 -RMQT 60 \
-U ALLOW_N_CIGAR_READS
done
