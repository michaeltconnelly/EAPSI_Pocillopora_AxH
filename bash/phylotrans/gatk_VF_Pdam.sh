#!/bin/bash
#BSUB -J gatk_VF_pdam
#BSUB -q general
#BSUB -P transcriptomics
#BSUB -o gatk_VF_pdam%J.out
#BSUB -e gatk_VF_pdam%J.err
#BSUB -n 8
#BSUB -u m.connelly1@umiami.edu

#~/scripts/EAPSI_HW-WT-master/gatk_VF_Pdam.sh
#/scratch/projects/transcriptomics/mikeconnelly/scripts/EAPSI_HW-WT-master/gatk_VF_Pdam.sh
#purpose: hard-filter variants for EAPSI SNP phylotranscriptomics analysis

#specify variable containing sequence file prefixes and directory paths
mcs="/scratch/projects/transcriptomics/mikeconnelly"
coldir="/scratch/projects/transcriptomics/mikeconnelly/sequences/EAPSI/houwanwanglitung"
exp="alltreatments"
EAPSIsamples="Hw1-6a Hw1-6b Hw1-6c Hw2-6b Hw2-6c Wt1-6a Wt1-6b Wt1-6c Wt2-6a Wt2-6b Wt2-6c"

#lets me know which files are being processed
echo "These are the bam files to be processed : $EAPSIsamples"

for EAPSIsample in $EAPSIsamples
do \
java \
-jar /share/apps/GATK/3.4.0/GenomeAnalysisTK.jar \
-T VariantFiltration \
-R ${mcs}/sequences/genomes/coral/pocillopora/pdam_genome.fasta \
-V ${coldir}/${exp}/STARalign_Pdam/${EAPSIsample}.g.vcf.gz \
-window 35 \
-cluster 3 \
-filterName FS \
-filter "FS > 30.0" \
-filterName QD \
-filter "QD < 2.0" \
-o  ${coldir}/${exp}/STARalign_Pdam/${EAPSIsample}.filtered.vcf.gz
done
