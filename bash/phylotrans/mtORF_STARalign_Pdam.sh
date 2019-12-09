#!/bin/bash
#~/computing/scripts/EAPSI_HW-WT_ncbi-master/STARalign_Pdam_mt.sh
#purpose: align trimmed RNAseq reads against the Pocillopora damicornis genome using STAR on the Pegasus bigmem queue

#specify variable containing sequence file prefixes
EAPSIsamples="Hw1-6a Hw1-6b Hw1-6c Hw2-6b Hw2-6c Wt1-6a Wt1-6b Wt1-6c Wt2-6a Wt2-6b Wt2-6c"

#Run STAR aligner
echo "These are the reads to be aligned to the Pocillopora reference genome: $EAPSIsamples"
for EAPSIsample in $EAPSIsamples
do \
echo "Aligning ${EAPSIsample}"
~/computing/programs/STAR \
--runMode alignReads \
--runThreadN 8 \
--readFilesIn ~/computing/sequences/${EAPSIsample}_trimmed.fastq.gz \
--readFilesCommand gunzip -c \
--genomeDir ~/computing/sequences/genomes/coral/pocillopora/mitochondria/STARindex \
--sjdbGTFfeatureExon exon \
--sjdbGTFtagExonParentTranscript Parent \
--sjdbGTFfile  ~/computing/sequences/genomes/coral/pocillopora/mitochondria/pdam_mt_ncbi.gff \
--twopassMode Basic \
--twopass1readsN -1 \
--outStd Log SAM BAM_Unsorted \
--outSAMtype BAM Unsorted \
--outFileNamePrefix ~/computing/sequences/genomes/coral/pocillopora/mitochondria/${EAPSIsample}_mt_

#lets me know file is done
echo "STAR alignment of $EAPSIsample complete"
done
