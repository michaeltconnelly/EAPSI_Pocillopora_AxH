#!/bin/bash
#source activate qiime2-2019.1
cd /Users/mikeconnelly/computing/scripts/EAPSI-bacteria/all_wd/

### Export rooted phylogenetic tree and taxonomic classification to .txt files
qiime tools export \
--input-path ./qza/all_gg_rooted-tree.qza \
--output-path ./export_gg

qiime tools export \
--input-path ./qza/all_classification_gg.qza \
--output-path ./export_gg

qiime tools export \
--input-path ./qza/all_gg_aligned-rep-seqs-no-mtcp.qza \
--output-path ./export_gg

### Export filtered feature table to BIOMv2 format file
qiime tools export \
--input-path ./qza/all_gg_table-no-mtcp.qza \
--output-path ./export_gg
### Convert BIOMv2 format feature table
biom convert \
-i ./export_gg/feature-table.biom \
--to-tsv \
-o ./export_gg/all_gg_feature-table.tsv

### Export rareified filtered feature table to BIOMv2 format file
qiime tools export \
--input-path ./core-metrics-results_gg/rarefied_table.qza \
--output-path ./export_gg_rare
### Convert BIOMv2 format feature table
biom convert \
-i ./export_gg_rare/feature-table.biom \
--to-tsv \
-o ./export_gg/all_gg_rarefied_feature-table.tsv

### Modify formatting of .tsv taxonomy tables
awk -F "\t" '{print $1"\t"$2}' ./export_gg/taxonomy.tsv > ./export_gg/taxonomy2.tsv
#need to insert literal tab
#sed 's/;/(ctrl + v + tab)/g' ./export/taxonomy2.tsv > ./export/taxonomy3.tsv
#grep -v "Feature" ./export/taxonomy3.tsv > ./export/taxonomy4.tsv
#need to open taxonomy4.tsv in Excel and save as tab-deliminted text

### Modify formatting of .tsv feature tables (rareified and unrareified)
sed 's/#OTU ID/ASVID/g' ./export_gg/all_gg_feature-table.tsv > ./export_gg/feature-table2.tsv
grep -v "Constructed" ./export_gg/feature-table2.tsv > ./export_gg/feature-table3.tsv
rm ./export_gg/all_gg_feature-table.tsv
rm ./export_gg/feature-table2.tsv
mv ./export_gg/feature-table3.tsv ./export_gg/all_gg_feature-table.tsv

sed 's/#OTU ID/ASVID/g' ./export_gg/all_gg_rarefied_feature-table.tsv > ./export_gg/all_rarefied_feature-table2.tsv
grep -v "Constructed" ./export_gg/all_rarefied_feature-table2.tsv > ./export_gg/all_rarefied_feature-table3.tsv
rm ./export_gg/all_gg_rarefied_feature-table.tsv
rm ./export_gg/all_rarefied_feature-table2.tsv
mv ./export_gg/all_rarefied_feature-table3.tsv ./export_gg/all_gg_rarefied_feature-table.tsv
