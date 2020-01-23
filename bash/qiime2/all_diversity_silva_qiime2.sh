#!/bin/bash
#source activate qiime2-2019.1
cd /Users/mikeconnelly/computing/scripts/EAPSI-bacteria/all_wd/

### Run core diversity metrics analysis on reads rareified to a depth of 2,600
qiime diversity core-metrics-phylogenetic \
--i-phylogeny ./qza/all_silva_rooted-tree.qza \
--i-table ./qza/all_silva_table-no-mtcp.qza \
--p-sampling-depth 2600 \
--m-metadata-file ./metadata/metadata_all.tsv \
--output-dir ./core-metrics-results_silva/

qiime diversity alpha-rarefaction \
  --i-table ./qza/all_silva_table-no-mtcp.qza \
  --i-phylogeny ./qza/all_silva_rooted-tree.qza \
  --p-max-depth 12000 \
  --m-metadata-file ./metadata/metadata_all.tsv \
  --o-visualization ./qzv/all_silva_alpha-rarefaction.qzv

### Create taxa barplot visualization
qiime taxa barplot \
  --i-table ./qza/all_silva_table-no-mtcp.qza \
  --i-taxonomy ./qza/all_classification_silva.qza \
  --m-metadata-file ./metadata/metadata_all.tsv \
  --o-visualization ./qzv/all_silva_barplot_no-mtcp.qzv \

  qiime feature-table summarize \
  --i-table ./core-metrics-results_silva/rarefied_table.qza \
  --o-visualization ./qzv/all_silva_rarefied_table.qzv

  ##move qza and qzv from diversity analyses to appropriate folders
  #mv ./core-metrics-results_silva/*.qza ./qza/
  #mv ./core-metrics-results_silva/*.qzv ./qzv/

bash ./all_export_silva_qiime2.sh
