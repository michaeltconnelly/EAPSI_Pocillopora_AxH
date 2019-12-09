#!/bin/bash
genotypes="Wt1 Wt2 Hw1 Hw2"
dir="/Users/mikeconnelly/computing/sequences/genomes/coral/pocillopora/mitochondria/EAPSI_mtAlign"

#extract consensus alignnment file using mpileup
~/computing/programs/samtools-1.3.1/samtools mpileup \
-f /Users/mikeconnelly/computing/sequences/genomes/coral/pocillopora/mitochondria/pdam_mt.fasta \
${dir}/Wt1-6c_mtORF_Aligned.sorted.out.bam \
${dir}/Wt2-6c_mtORF_Aligned.sorted.out.bam \
${dir}/Hw1-6c_mtORF_Aligned.sorted.out.bam \
${dir}/Hw2-6c_mtORF_Aligned.sorted.out.bam \
-r "NC_009797.1:7548-8456" \
-o ${dir}/EAPSI_mtORF.pileup
