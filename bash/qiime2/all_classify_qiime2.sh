#!/bin/bash
#purpose: Classify ASVs using qiime2 feature-classifier trained for 16S V4 region
#conda activate qiime2-2019.10

prodir="/Users/mikeconnelly/computing/projects/EAPSI_Pocillopora_AxH"
exp="AxH"
EAPSIsamples="Wt1-1a Wt1-1b Wt1-1c Wt1-4a Wt1-4b Wt1-4c Wt1-5a Wt1-5b Wt1-5c Wt1-6a Wt1-6b Wt1-6c Wt2-1a Wt2-1b Wt2-1c Wt2-4a Wt2-4b Wt2-4c Wt2-5a Wt2-5b Wt2-5c Wt2-6a Wt2-6b Wt2-6c Hw1-1a Hw1-1b Hw1-1c Hw1-4a Hw1-4b Hw1-4c Hw1-5a Hw1-5b Hw1-5c Hw1-6a Hw1-6b Hw1-6c Hw2-1a Hw2-1b Hw2-1c Hw2-4a Hw2-4b Hw2-4c Hw2-5a Hw2-5b Hw2-5c Hw2-6b Hw2-6c"
echo "QIIME2 classification process started"

### Classify representative sequences using a Naive Bayesian classifier trained using the 99% similarity Silva 132 reference sequences
### Remove all mitochondria and chloroplast sequences from classified representative sequences
### Remove all mitochondria and chloroplast sequences from classified feature table
### Create phylogenetic tree
qiime feature-classifier classify-sklearn \
  --i-classifier ${prodir}/data/classifiers/silva-132-99-515-806-nb-classifier.qza \
  --i-reads ${prodir}/outputs/qiime2/qza/all_rep-seqs.qza \
  --o-classification ${prodir}/outputs/qiime2/qza/all_classification_silva.qza

qiime metadata tabulate \
  --m-input-file ${prodir}/outputs/qiime2/qza/all_classification_silva.qza \
  --o-visualization ${prodir}/outputs/qiime2/qzv/all_classification_silva.qzv

qiime taxa filter-seqs \
  --i-sequences ${prodir}/outputs/qiime2/qza/all_rep-seqs.qza \
  --i-taxonomy ${prodir}/outputs/qiime2/qza/all_classification_silva.qza \
  --p-exclude mitochondria,chloroplast \
  --o-filtered-sequences ${prodir}/outputs/qiime2/qza/all_silva_rep-seqs-no-mtcp.qza
qiime feature-table tabulate-seqs \
  --i-data ${prodir}/outputs/qiime2/qza/all_silva_rep-seqs-no-mtcp.qza \
  --o-visualization ${prodir}/outputs/qiime2/qzv/all_silva_rep-seqs-no-mtcp_rep-seqs.qzv

qiime taxa filter-table \
  --i-table ${prodir}/outputs/qiime2/qza/all_table.qza \
  --i-taxonomy ${prodir}/outputs/qiime2/qza/all_classification_silva.qza \
  --p-exclude mitochondria,chloroplast \
  --o-filtered-table ${prodir}/outputs/qiime2/qza/all_silva_table-no-mtcp.qza
qiime feature-table summarize \
  --i-table ${prodir}/outputs/qiime2/qza/all_silva_table-no-mtcp.qza \
  --o-visualization ${prodir}/outputs/qiime2/qzv/all_silva_table-no-mtcp.qzv \

qiime phylogeny align-to-tree-mafft-fasttree \
--i-sequences ${prodir}/outputs/qiime2/qza/all_silva_rep-seqs-no-mtcp.qza \
--o-alignment ${prodir}/outputs/qiime2/qza/all_silva_aligned-rep-seqs-no-mtcp.qza \
--o-masked-alignment ${prodir}/outputs/qiime2/qza/all_silva_masked-aligned-rep-seqs-no-mtcp.qza \
--o-tree ${prodir}/outputs/qiime2/qza/all_silva_unrooted-tree.qza \
--o-rooted-tree ${prodir}/outputs/qiime2/qza/all_silva_rooted-tree.qza

bash ${prodir}/bash/qiime2/all_diversity_silva_qiime2.sh
