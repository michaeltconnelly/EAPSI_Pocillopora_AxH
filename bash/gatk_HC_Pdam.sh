#!/bin/bash
#./bash/gatk_HC_Pdam.sh
#purpose: call haplotype variants for EAPSI SNP phylotranscriptomics analysis
#To start this job from the EAPSI_Pocillopora_AxH directory, use:
#bsub -P transcriptomics < ./bash/gatk_HC_Pdam.sh

#BSUB -J gatk_HC_pdam
#BSUB -q general
#BSUB -P transcriptomics
#BSUB -o gatk_HC_pdam%J.out
#BSUB -e gatk_HC_pdam%J.err
#BSUB -n 8
#BSUB -u m.connelly1@umiami.edu

#specify variable containing sequence file prefixes and directory paths
mcs="/scratch/projects/transcriptomics/mikeconnelly"
prodir="/scratch/projects/transcriptomics/mikeconnelly/projects/EAPSI_Pocillopora_AxH"
exp="AxH"
EAPSIsamples="Wt1-1a Wt1-1b Wt1-1c Wt1-4a Wt1-4b Wt1-4c Wt1-5a Wt1-5b Wt1-5c Wt1-6a Wt1-6b Wt1-6c Wt2-1a Wt2-1b Wt2-1c Wt2-4a Wt2-4b Wt2-4c Wt2-5a Wt2-5b Wt2-5c Wt2-6a Wt2-6b Wt2-6c Hw1-1a Hw1-1b Hw1-1c Hw1-4a Hw1-4b Hw1-4c Hw1-5a Hw1-5b Hw1-5c Hw1-6a Hw1-6b Hw1-6c Hw2-1a Hw2-1b Hw2-1c Hw2-4a Hw2-4b Hw2-4c Hw2-5a Hw2-5b Hw2-5c Hw2-6b Hw2-6c"

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
-I ${prodir}/outputs/phylotrans_Pdam/${EAPSIsample}_PdamAligned.sorted.out.md.rg.splitN.bam \
-o ${prodir}/outputs/phylotrans_Pdam/${EAPSIsample}.g.vcf.gz \
-R ${mcs}/sequences/genomes/coral/pocillopora/pdam_genome.fasta \
-stand_call_conf 20.0 \
-dontUseSoftClippedBases
done

bsub -P transcriptomics < ./bash/gatk_VF_Pdam.sh
echo "Started next job in phylotranscriptomics pipeline: GATK VariantFiltration"
