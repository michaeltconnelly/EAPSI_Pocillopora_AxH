#!/bin/bash

#merge two separate callsets
java -jar GenomeAnalysisTK.jar \
   -T CombineVariants \
   -R reference.fasta \
   --variant input1.vcf \
   --variant input2.vcf \
   -o output.vcf \
   -genotypeMergeOptions UNIQUIFY

#give the union of calls made on the same set of samples (ie. per-genotype)
java -jar GenomeAnalysisTK.jar \
   -T CombineVariants \
   -R reference.fasta \
   --variant:a input1.vcf \
   --variant:b input2.vcf \
   --variant:c input3.vcf \
   -o output.vcf \
   -genotypeMergeOptions PRIORITIZE \
   -priority foo,bar
