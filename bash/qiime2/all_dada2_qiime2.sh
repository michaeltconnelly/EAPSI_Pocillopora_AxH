#!/bin/bash
#purpose: Use DADA2 to dereplicate and merge paired-end reads and create feature table of ASVs
#conda activate qiime2-2019.10

prodir="/Users/mikeconnelly/computing/projects/EAPSI_Pocillopora_AxH"
exp="AxH"
EAPSIsamples="Wt1-1a Wt1-1b Wt1-1c Wt1-4a Wt1-4b Wt1-4c Wt1-5a Wt1-5b Wt1-5c Wt1-6a Wt1-6b Wt1-6c Wt2-1a Wt2-1b Wt2-1c Wt2-4a Wt2-4b Wt2-4c Wt2-5a Wt2-5b Wt2-5c Wt2-6a Wt2-6b Wt2-6c Hw1-1a Hw1-1b Hw1-1c Hw1-4a Hw1-4b Hw1-4c Hw1-5a Hw1-5b Hw1-5c Hw1-6a Hw1-6b Hw1-6c Hw2-1a Hw2-1b Hw2-1c Hw2-4a Hw2-4b Hw2-4c Hw2-5a Hw2-5b Hw2-5c Hw2-6b Hw2-6c"
echo "DADA2 dereplicaton and summarization process started"

### Denoise, dereplicate and merge paired-end reads using DADA2
### Create feature table and representative sequences
 qiime dada2 denoise-paired \
 --i-demultiplexed-seqs ${prodir}/outputs/qiime2/qza/all.qza \
 --p-trunc-len-f 200 \
 --p-trunc-len-r 180 \
 --p-trim-left-f 5 \
 --p-trim-left-r 5 \
 --p-trunc-q 20 \
 --o-table ${prodir}/outputs/qiime2/qza/all_table.qza \
 --o-representative-sequences ${prodir}/outputs/qiime2/qza/all_rep-seqs.qza \
 --o-denoising-stats ${prodir}/outputs/qiime2/qza/all_denoise-stats.qza \

 qiime feature-table summarize \
 --i-table ${prodir}/outputs/qiime2/qza/all_table.qza \
 --o-visualization ${prodir}/outputs/qiime2/qzv/all_table.qzv \
 --m-sample-metadata-file ${prodir}/data/qiime2_metadata.tsv

 qiime feature-table tabulate-seqs \
 --i-data ${prodir}/outputs/qiime2/qza/all_rep-seqs.qza \
 --o-visualization ${prodir}/outputs/qiime2/qzv/all_rep-seqs.qzv
###      854 representative sequences (features) after denoising and dereplication
 qiime metadata tabulate \
 --m-input-file ${prodir}/outputs/qiime2/qza/all_denoise-stats.qza \
 --o-visualization ${prodir}/outputs/qiime2/qzv/all_denoise-stats.qzv
###      Between 704 - 21,152 non-chimeric reads per sample

bash ${prodir}/bash/qiime2/all_classify_qiime2.sh
