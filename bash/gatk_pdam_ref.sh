#!/bin/bash
#BSUB -J gatk_pdam_ref
#BSUB -q general
#BSUB -P transcriptomics
#BSUB -o gatk_ref_pdam%J.out
#BSUB -e gatk_ref_pdam%J.err
#BSUB -n 8
#BSUB -u m.connelly1@umiami.edu

#~/scripts/EAPSI.HW-WT-master/gatk_pdam_ref.sh
#/scratch/projects/transcriptomics/mikeconnelly/scripts/EAPSI.HW-WT-master/gatk_pdam_ref.sh
#purpose: create genome fasta reference dictionary and index for GATK processing

#specify variable containing sequence file prefixes and directory paths
mcs="/scratch/projects/transcriptomics/mikeconnelly"
coldir="/scratch/projects/transcriptomics/mikeconnelly/sequences/EAPSI/houwanwanglitung"
exp="alltreatments"
EAPSIsamples="Hw1-6a Hw1-6b Hw1-6c Hw2-6b Hw2-6c Wt1-6a Wt1-6b Wt1-6c Wt2-6a Wt2-6b Wt2-6c"

module load java/1.8.0_60
module load samtools/1.3
module load picard-tools/1.103
module load bwa/0.7.4
module load GATK/3.4.0

java -jar /share/apps/picard-tools/1.103/CreateSequenceDictionary.jar \
R=${mcs}/sequences/genomes/coral/pocillopora/pdam_genome.fasta \
O=${mcs}/sequences/genomes/coral/pocillopora/pdam_genome.dict

samtools faidx ${mcs}/sequences/genomes/coral/pocillopora/pdam_genome.fasta
