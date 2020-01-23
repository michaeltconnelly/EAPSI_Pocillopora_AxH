#!/bin/bash
#source activate qiime2-2019.1
cd /Users/mikeconnelly/computing/scripts/EAPSI-bacteria/all_wd/

### Denoise, dereplicate and merge paired-end reads using DADA2
### Create feature table and representative sequences
 qiime dada2 denoise-paired \
 --i-demultiplexed-seqs ./qza/all.qza \
 --p-trunc-len-f 200 \
 --p-trunc-len-r 180 \
 --p-trim-left-f 5 \
 --p-trim-left-r 5 \
 --p-trunc-q 20 \
 --o-table ./qza/all_table.qza \
 --o-representative-sequences ./qza/all_rep-seqs.qza \
 --o-denoising-stats ./qza/all_denoise-stats.qza \

 qiime feature-table summarize \
 --i-table ./qza/all_table.qza \
 --o-visualization ./qzv/all_table.qzv \
 --m-sample-metadata-file ./metadata/metadata_all.tsv

 qiime feature-table tabulate-seqs \
 --i-data ./qza/all_rep-seqs.qza \
 --o-visualization ./qzv/all_rep-seqs.qzv
###      854 representative sequences (features) after denoising and dereplication
 qiime metadata tabulate \
 --m-input-file ./qza/all_denoise-stats.qza \
 --o-visualization ./qzv/all_denoise-stats.qzv
###      Between 704 - 21,152 non-chimeric reads per sample

bash ./all_classify_qiime2.sh
