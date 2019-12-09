#!/bin/bash
genotypes="Wt1 Wt2 Hw1 Hw2"
dir="/Users/mikeconnelly/computing/sequences/genomes/coral/pocillopora/mitochondria/EAPSI_mtAlign"

#sort output bam files
#~/computing/programs/samtools-1.3.1/samtools sort \
#/Users/mikeconnelly/computing/sequences/${genotype}-6c_mt_Aligned.out.bam \
#> /Users/mikeconnelly/computing/sequences/${genotype}-6c_mt_Aligned.sorted.out.bam

#index sorted bam files
for genotype in $genotypes
do \
~/computing/programs/samtools-1.3.1/samtools index -b \
${dir}/${genotype}-6c_mt_Aligned.sorted.out.bam
done

#convert mt genome aligned bam files into fastq reads
for genotype in $genotypes
do \
~/computing/programs/bedtools2/bin/bedtools bamtofastq \
-i ${dir}/${genotype}-6c_mt_Aligned.sorted.out.bam \
-fq ${dir}/${genotype}-6c_mt_Aligned.fastq
done

#output bam file for mtORF region coordinates
for genotype in $genotypes
do \
~/computing/programs/samtools-1.3.1/samtools view -b -h \
${dir}/${genotype}-6c_mt_Aligned.sorted.out.bam \
"NC_009797.1:7548-8456" \
-o ${dir}/${genotype}-6c_mtORF_Aligned.sorted.out.bam
done

#index mtORF region sorted bam files
for genotype in $genotypes
do \
~/computing/programs/samtools-1.3.1/samtools index -b \
${dir}/${genotype}-6c_mtORF_Aligned.sorted.out.bam
done

#convert mtORF region bams into fastqs
for genotype in $genotypes
do \
~/computing/programs/samtools-1.3.1/samtools fastq \
${dir}/${genotype}-6c_mtORF_Aligned.sorted.out.bam \
> ${dir}/${genotype}-6c_mtORF_Aligned.sorted.out.fastq
done

#convert mtORF region bams into fastas
for genotype in $genotypes
do \
~/computing/programs/samtools-1.3.1/samtools fasta \
${dir}/${genotype}-6c_mtORF_Aligned.sorted.out.bam \
> ${dir}/${genotype}-6c_mtORF_Aligned.sorted.out.fasta
done

#extract consensus alignnment file using mpileup
for genotype in $genotypes
do \
~/computing/programs/samtools-1.3.1/samtools mpileup \
-f /Users/mikeconnelly/computing/sequences/genomes/coral/pocillopora/mitochondria/pdam_mt.fasta \
${dir}/${genotype}-6c_mtORF_Aligned.sorted.out.bam \
-r "NC_009797.1:7548-8456" \
-o ${dir}/${genotype}-6c_mtORF_Aligned.sorted.out.pileup
done

#~/computing/programs/bcftools-1.9/bin/bcftools
