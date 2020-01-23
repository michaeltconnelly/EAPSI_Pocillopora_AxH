#!/bin/bash
#source activate qiime2-2019.1
cd /Users/mikeconnelly/computing/scripts/EAPSI-bacteria/all_wd/

### Classify representative sequences using a Naive Bayesian classifier trained using the 99% similarity Silva 132 reference sequences
### Remove all mitochondria and chloroplast sequences from classified representative sequences
### Remove all mitochondria and chloroplast sequences from classified feature table
### Create phylogenetic tree
qiime feature-classifier classify-sklearn \
  --i-classifier ../classifiers/silva-132-99-515-806-nb-classifier.qza \
  --i-reads ./qza/all_rep-seqs.qza \
  --o-classification ./qza/all_classification_silva.qza

qiime metadata tabulate \
  --m-input-file ./qza/all_classification_silva.qza \
  --o-visualization ./qzv/all_classification_silva.qzv

qiime taxa filter-seqs \
  --i-sequences ./qza/all_rep-seqs.qza \
  --i-taxonomy ./qza/all_classification_silva.qza \
  --p-exclude mitochondria,chloroplast \
  --o-filtered-sequences ./qza/all_silva_rep-seqs-no-mtcp.qza
qiime feature-table tabulate-seqs \
  --i-data ./qza/all_silva_rep-seqs-no-mtcp.qza \
  --o-visualization ./qzv/all_silva_rep-seqs-no-mtcp_rep-seqs.qzv

qiime taxa filter-table \
  --i-table ./qza/all_table.qza \
  --i-taxonomy ./qza/all_classification_silva.qza \
  --p-exclude mitochondria,chloroplast \
  --o-filtered-table ./qza/all_silva_table-no-mtcp.qza
qiime feature-table summarize \
  --i-table ./qza/all_silva_table-no-mtcp.qza \
  --o-visualization ./qzv/all_silva_table-no-mtcp.qzv \

qiime phylogeny align-to-tree-mafft-fasttree \
--i-sequences ./qza/all_silva_rep-seqs-no-mtcp.qza \
--o-alignment ./qza/all_silva_aligned-rep-seqs-no-mtcp.qza \
--o-masked-alignment ./qza/all_silva_masked-aligned-rep-seqs-no-mtcp.qza \
--o-tree ./qza/all_silva_unrooted-tree.qza \
--o-rooted-tree ./qza/all_silva_rooted-tree.qza

### Classify representative sequences using a Naive Bayesian classifier trained using the 99% similarity Greengenes reference sequences
### Remove all mitochondria and chloroplast sequences from classified representative sequences
### Remove all mitochondria and chloroplast sequences from classified feature table
### Create phylogenetic tree
qiime feature-classifier classify-sklearn \
  --i-classifier ../classifiers/gg-13-8-99-515-806-nb-classifier.qza \
  --i-reads ./qza/all_rep-seqs.qza \
  --o-classification ./qza/all_classification_gg.qza

qiime metadata tabulate \
  --m-input-file ./qza/all_classification_gg.qza \
  --o-visualization ./qzv/all_classification_gg.qzv

qiime taxa filter-seqs \
  --i-sequences ./qza/all_rep-seqs.qza \
  --i-taxonomy ./qza/all_classification_gg.qza \
  --p-exclude mitochondria,chloroplast \
  --o-filtered-sequences ./qza/all_gg_rep-seqs-no-mtcp.qza
qiime feature-table tabulate-seqs \
  --i-data ./qza/all_gg_rep-seqs-no-mtcp.qza \
  --o-visualization ./qzv/all_gg_rep-seqs-no-mtcp_rep-seqs.qzv

qiime taxa filter-table \
  --i-table ./qza/all_table.qza \
  --i-taxonomy ./qza/all_classification_gg.qza \
  --p-exclude mitochondria,chloroplast \
  --o-filtered-table ./qza/all_gg_table-no-mtcp.qza
qiime feature-table summarize \
  --i-table ./qza/all_gg_table-no-mtcp.qza \
  --o-visualization ./qzv/all_gg_table-no-mtcp.qzv \

qiime phylogeny align-to-tree-mafft-fasttree \
--i-sequences ./qza/all_gg_rep-seqs-no-mtcp.qza \
--o-alignment ./qza/all_gg_aligned-rep-seqs-no-mtcp.qza \
--o-masked-alignment ./qza/all_gg_masked-aligned-rep-seqs-no-mtcp.qza \
--o-tree ./qza/all_gg_unrooted-tree.qza \
--o-rooted-tree ./qza/all_gg_rooted-tree.qza

### Classify representative sequences using a Naive Bayesian classifier trained using the 99% similarity RefSeq RDP reference sequences


bash ./all_diversity_silva_qiime2.sh
bash ./all_diversity_gg_qiime2.sh
