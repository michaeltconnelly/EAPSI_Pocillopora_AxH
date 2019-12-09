#!/bin/bash
#BSUB -J gatk_BSQR_pdam
#BSUB -q general
#BSUB -P transcriptomics
#BSUB -o gatk_BSQR_pdam%J.out
#BSUB -e gatk_BSQR_pdam%J.err
#BSUB -n 8
#BSUB -u m.connelly1@umiami.edu

#~/scripts/EAPSI.HW-WT-master/gatk_BSQR_Pdam.sh
#/scratch/projects/transcriptomics/mikeconnelly/scripts/EAPSI.HW-WT-master/gatk_BSQR_Pdam.sh
#purpose: Base Quality Recalibration preprocessing for bam files

#specify variable containing sequence file prefixes and directory paths
mcs="/scratch/projects/transcriptomics/mikeconnelly"
coldir="/scratch/projects/transcriptomics/mikeconnelly/sequences/EAPSI/houwanwanglitung"
exp="alltreatments"
EAPSIsamples="Hw1-6a Hw1-6b Hw1-6c Hw2-6b Hw2-6c Wt1-6a Wt1-6b Wt1-6c Wt2-6a Wt2-6b Wt2-6c"

#lets me know which files are being processed
echo "These are the bam files to be processed : $EAPSIsamples"
#--filter_reads_with_N_cigar
for EAPSIsample in $EAPSIsamples
do \
java \
-jar /share/apps/GATK/3.4.0/GenomeAnalysisTK.jar \
-T BaseRecalibrator \
-R ${mcs}/sequences/genomes/coral/pocillopora/pdam_genome.fasta \
-I ${coldir}/${exp}/STARalign_Pdam/${EAPSIsample}_PdamAligned.sorted.out.md.rg.splitN.bam \
--known-sites sites_of_variation.vcf \
-o ${coldir}/${exp}/STARalign_Pdam/${EAPSIsample}_Pdam_recal_data.table.grp
done

for EAPSIsample in $EAPSIsamples
do \
java \
-jar /share/apps/GATK/3.4.0/GenomeAnalysisTK.jar \
-T ApplyBQSR \
-R ${mcs}/sequences/genomes/coral/pocillopora/pdam_genome.fasta \
-I ${coldir}/${exp}/STARalign_Pdam/${EAPSIsample}_PdamAligned.sorted.out.md.rg.splitN.bam \
--bqsr-recal-file ${coldir}/${exp}/STARalign_Pdam/${EAPSIsample}_Pdam_recal_data.table.grp \
-O ${coldir}/${exp}/STARalign_Pdam/${EAPSIsample}_PdamAligned.sorted.out.md.rg.splitN.BSQR.bam
done

for EAPSIsample in $EAPSIsamples
do \
java -jar /share/apps/GATK/3.4.0/GenomeAnalysisTK.jar \
-T PrintReads \
-R ${mcs}/sequences/genomes/coral/pocillopora/pdam_genome.fasta \
-I ${coldir}/${exp}/STARalign_Pdam/${EAPSIsample}_PdamAligned.sorted.out.md.rg.splitN.bam \
-BQSR ${coldir}/${exp}/STARalign_Pdam/${EAPSIsample}_Pdam_recal_data.table.grp \
-o ${coldir}/${exp}/STARalign_Pdam/${EAPSIsample}_PdamAligned.sorted.out.md.rg.splitN.BSQR.bam
 done
