#!/bin/bash
#~/scripts/EAPSI.HW-WT-master/STARfC_SymC1.sh
#/scratch/projects/transcriptomics/mikeconnelly/scripts/EAPSI.HW-WT-master/STARfC_SymC1.sh
#purpose: quantify Pocillopora damicornis aligned RNAseq transcript abundances using featureCounts program to create a counts table on Pegasus

#BSUB -J starfC_symC1
#BSUB -q general
#BSUB -P transcriptomics
#BSUB -o starfC_symC1%J.out
#BSUB -e starfC_symC1%J.err
#BSUB -n 16
#BSUB -W 6:00
#BSUB -u mconnelly@rsmas.miami.edu
#BSUB -N

#specify variable containing sequence file prefixes, experiment design and directory paths
mcs="/scratch/projects/transcriptomics/mikeconnelly"
coldir="/scratch/projects/transcriptomics/mikeconnelly/sequences/EAPSI/houwanwanglitung"
exp="alltreatments"
EAPSIsamples="Wt1-1a Wt1-1b Wt1-1c Wt1-2a Wt1-2b Wt1-3a Wt1-3b Wt1-3c Wt1-4a Wt1-4b Wt1-4c Wt1-5a Wt1-5b Wt1-5c Wt1-6a Wt1-6b Wt1-6c Wt2-1a Wt2-1b Wt2-1c Wt2-2b Wt2-2c Wt2-3a Wt2-3b Wt2-3c Wt2-4a Wt2-4b Wt2-4c Wt2-5a Wt2-5b Wt2-5c Wt2-6a Wt2-6b Wt2-6c Hw1-1a Hw1-1b Hw1-1c Hw1-2a Hw1-2b Hw1-2c Hw1-3a Hw1-3b Hw1-3c Hw1-4a Hw1-4b Hw1-4c Hw1-5a Hw1-5b Hw1-5c Hw1-6a Hw1-6b Hw1-6c Hw2-1a Hw2-1b Hw2-1c Hw2-2a Hw2-2b Hw2-2c Hw2-3a Hw2-3b Hw2-3c Hw2-4a Hw2-4b Hw2-4c Hw2-5a Hw2-5b Hw2-5c Hw2-6b Hw2-6c"
echo "These are the .bam files to be quantified using featureCounts"
echo $EAPSIsamples
${mcs}/programs/subread-1.6.0-Linux-x86_64/bin/featureCounts -t gene \
-g ID \
-a ${mcs}/sequences/genomes/symbiodinium/symC1_genome.gff \
-o ${coldir}/${exp}/STARcounts_SymC1/${exp}_SymC1.counts \
${coldir}/${exp}/STARalign_SymC1/*Aligned.out.bam
