#!/bin/bash
#BSUB -J gatk_HC_pdam
#BSUB -q general
#BSUB -P transcriptomics
#BSUB -o gatk_HC_pdam%J.out
#BSUB -e gatk_HC_pdam%J.err
#BSUB -n 8
#BSUB -u m.connelly1@umiami.edu

#~/scripts/EAPSI.HW-WT-master/gatk_HC_Pdam.sh
#/scratch/projects/transcriptomics/mikeconnelly/scripts/EAPSI.HW-WT-master/gatk_HC_Pdam.sh
#purpose: call haplotype variants for EAPSI SNP phylotranscriptomics analysis

#specify variable containing sequence file prefixes and directory paths
mcs="/scratch/projects/transcriptomics/mikeconnelly"
coldir="/scratch/projects/transcriptomics/mikeconnelly/sequences/EAPSI/houwanwanglitung"
exp="alltreatments"
EAPSIsamples="Hw1-6a Hw1-6b Hw1-6c Hw2-6b Hw2-6c Wt1-6a Wt1-6b Wt1-6c Wt2-6a Wt2-6b Wt2-6c"

#lets me know which files are being processed
echo "These are the bam files to be processed : $EAPSIsamples"

#-ERC GVCF \
#-variant_index_type LINEAR -variant_index_parameter 128000 \
#-G Standard
for EAPSIsample in $EAPSIsamples
do \
java \
-jar /share/apps/GATK/3.4.0/GenomeAnalysisTK.jar \
-T HaplotypeCaller \
-I ${coldir}/${exp}/STARalign_Pdam/${EAPSIsample}_PdamAligned.sorted.out.md.rg.splitN.bam \
-o ${coldir}/${exp}/STARalign_Pdam/${EAPSIsample}.g.vcf.gz \
-R ${mcs}/sequences/genomes/coral/pocillopora/pdam_genome.fasta \
-stand_call_conf 20.0 \
-dontUseSoftClippedBases
done
