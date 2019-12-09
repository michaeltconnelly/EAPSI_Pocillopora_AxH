#!/bin/bash
genotypes="Wt1 Wt2 Hw1 Hw2"
dir="/Users/mikeconnelly/computing/sequences/genomes/coral/pocillopora/mitochondria/EAPSI_mtAlign"

# extract consensus alignnment file using mpileup
# call variants
bcftools mpileup -Ou \
-f /Users/mikeconnelly/computing/sequences/genomes/coral/pocillopora/mitochondria/pdam_mt.fasta \
${dir}/Wt1-6c_mtORF_Aligned.sorted.out.bam \
${dir}/Wt2-6c_mtORF_Aligned.sorted.out.bam \
${dir}/Hw1-6c_mtORF_Aligned.sorted.out.bam \
${dir}/Hw2-6c_mtORF_Aligned.sorted.out.bam \
-r "NC_009797.1:7548-8456" | bcftools call -mv -Oz -o ${dir}/calls.vcf.gz
#-o ${dir}/EAPSI_mtORF.pileup
bcftools index ${dir}/calls.vcf.gz

# normalize indels
bcftools norm -f /Users/mikeconnelly/computing/sequences/genomes/coral/pocillopora/mitochondria/pdam_mt.fasta ${dir}/calls.vcf.gz -Ob -o ${dir}/calls.norm.bcf

# filter adjacent indels within 5bp
bcftools filter --IndelGap 5 ${dir}/calls.norm.bcf -Ob -o ${dir}/calls.norm.flt-indels.bcf

# call consensus
samtools faidx /Users/mikeconnelly/computing/sequences/genomes/coral/pocillopora/mitochondria/pdam_mt.fasta \
NC_009797.1:7548-8456 | bcftools consensus ${dir}/calls.vcf.gz > ${dir}/consensus_mtORF.fasta
