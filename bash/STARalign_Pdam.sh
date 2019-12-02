#!/bin/bash
#~/scripts/EAPSI.HW-WT-master/STARalign_Pdam.sh
#/scratch/projects/transcriptomics/mikeconnelly/scripts/EAPSI.HW-WT-master/STARalign_Pdam.sh
#purpose: align trimmed RNAseq reads against the Pocillopora damicornis genome using STAR on the Pegasus bigmem queue

#BSUB -J staralign_pdam
#BSUB -q bigmem
#BSUB -P transcriptomics
#BSUB -o star_pdam%J.out
#BSUB -e star_pdam%J.err
#BSUB -n 8
#BSUB -W 6:00
#BSUB -u mconnelly@rsmas.miami.edu
#BSUB -N

#specify variable containing sequence file prefixes and directory paths
mcs="/scratch/projects/transcriptomics/mikeconnelly"
coldir="/scratch/projects/transcriptomics/mikeconnelly/sequences/EAPSI/houwanwanglitung"
exp="alltreatments"
EAPSIsamples="Wt1-1a Wt1-1b Wt1-1c Wt1-2a Wt1-2b Wt1-3a Wt1-3b Wt1-3c Wt1-4a Wt1-4b Wt1-4c Wt1-5a Wt1-5b Wt1-5c Wt1-6a Wt1-6b Wt1-6c Wt2-1a Wt2-1b Wt2-1c Wt2-2b Wt2-2c Wt2-3a Wt2-3b Wt2-3c Wt2-4a Wt2-4b Wt2-4c Wt2-5a Wt2-5b Wt2-5c Wt2-6a Wt2-6b Wt2-6c Hw1-1a Hw1-1b Hw1-1c Hw1-2a Hw1-2b Hw1-2c Hw1-3a Hw1-3b Hw1-3c Hw1-4a Hw1-4b Hw1-4c Hw1-5a Hw1-5b Hw1-5c Hw1-6a Hw1-6b Hw1-6c Hw2-1a Hw2-1b Hw2-1c Hw2-2a Hw2-2b Hw2-2c Hw2-3a Hw2-3b Hw2-3c Hw2-4a Hw2-4b Hw2-4c Hw2-5a Hw2-5b Hw2-5c Hw2-6b Hw2-6c"
#Run STAR aligner
echo "These are the reads to be aligned to the Pocillopora reference genome: $EAPSIsamples"
for EAPSIsample in $EAPSIsamples
do \
echo "Aligning ${EAPSIsample}"
${mcs}/programs/STAR-2.5.3a/bin/Linux_x86_64/STAR \
--runMode alignReads \
--runThreadN 16 \
--readFilesIn ${coldir}/${exp}/trimmomaticreads/${EAPSIsample}_trimmed.fastq.gz \
--readFilesCommand gunzip -c \
--genomeDir ${mcs}/sequences/genomes/coral/pocillopora/STARindex \
--sjdbGTFtagExonParentTranscript Parent \
--sjdbGTFfile  ${mcs}/sequences/genomes/coral/pocillopora/pdam_genome.gff \
--outSAMtype BAM Unsorted \
--outFileNamePrefix ${coldir}/${exp}/STARalign_Pdam/${EAPSIsample}_Pdam
#lets me know file is done
echo "STAR alignment of $EAPSIsample complete"
done

#Call next scripts in analysis pipeline
bsub -P transcriptomics < /scratch/projects/transcriptomics/mikeconnelly/scripts/EAPSI.HW-WT-master/STARfC_Pdam.sh
