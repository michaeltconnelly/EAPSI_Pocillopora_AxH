#!/bin/bash
#purpose: Calculate core diversity metrics and generate rarefaction statistics on ASVs classified against SILVA database
#conda activate qiime2-2019.10

prodir="/Users/mikeconnelly/computing/projects/EAPSI_Pocillopora_AxH"
exp="AxH"
EAPSIsamples="Wt1-1a Wt1-1b Wt1-1c Wt1-4a Wt1-4b Wt1-4c Wt1-5a Wt1-5b Wt1-5c Wt1-6a Wt1-6b Wt1-6c Wt2-1a Wt2-1b Wt2-1c Wt2-4a Wt2-4b Wt2-4c Wt2-5a Wt2-5b Wt2-5c Wt2-6a Wt2-6b Wt2-6c Hw1-1a Hw1-1b Hw1-1c Hw1-4a Hw1-4b Hw1-4c Hw1-5a Hw1-5b Hw1-5c Hw1-6a Hw1-6b Hw1-6c Hw2-1a Hw2-1b Hw2-1c Hw2-4a Hw2-4b Hw2-4c Hw2-5a Hw2-5b Hw2-5c Hw2-6b Hw2-6c"
echo "Core diversity analyses started for SILVA"

### Run core diversity metrics analysis on reads rareified to a depth of 2,600
qiime diversity core-metrics-phylogenetic \
--i-phylogeny ${prodir}/outputs/qiime2/qza/all_silva_rooted-tree.qza \
--i-table ${prodir}/outputs/qiime2/qza/all_silva_table-no-mtcp.qza \
--p-sampling-depth 2600 \
--m-metadata-file ${prodir}/data/qiime2_metadata.tsv \
--output-dir ${prodir}/outputs/qiime2/core-metrics-results_silva/

qiime diversity alpha-rarefaction \
  --i-table ${prodir}/outputs/qiime2/qza/all_silva_table-no-mtcp.qza \
  --i-phylogeny ${prodir}/outputs/qiime2/qza/all_silva_rooted-tree.qza \
  --p-max-depth 12000 \
  --m-metadata-file ${prodir}/data/qiime2_metadata.tsv \
  --o-visualization ${prodir}/outputs/qiime2/qzv/all_silva_alpha-rarefaction.qzv

### Create taxa barplot visualization
qiime taxa barplot \
  --i-table ${prodir}/outputs/qiime2/qza/all_silva_table-no-mtcp.qza \
  --i-taxonomy ${prodir}/outputs/qiime2/qza/all_classification_silva.qza \
  --m-metadata-file ${prodir}/data/qiime2_metadata.tsv \
  --o-visualization ${prodir}/outputs/qiime2/qzv/all_silva_barplot_no-mtcp.qzv \

  qiime feature-table summarize \
  --i-table ${prodir}/outputs/qiime2/core-metrics-results_silva/rarefied_table.qza \
  --o-visualization ${prodir}/outputs/qiime2/qzv/all_silva_rarefied_table.qzv

  ##move qza and qzv from diversity analyses to appropriate folders
  #mv ./core-metrics-results_silva/*.qza ${prodir}/outputs/qiime2/qza/
  #mv ./core-metrics-results_silva/*.qzv ${prodir}/outputs/qiime2/qzv/

bash ${prodir}/bash/qiime2/all_export_silva_qiime2.sh
