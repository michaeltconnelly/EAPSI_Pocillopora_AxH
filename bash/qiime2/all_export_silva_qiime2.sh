#!/bin/bash
#source activate qiime2-2019.1
cd /Users/mikeconnelly/computing/scripts/EAPSI-bacteria/all_wd/

### Export rooted phylogenetic tree and taxonomic classification to .txt files
qiime tools export \
--input-path ./qza/all_silva_rooted-tree.qza \
--output-path ./export_silva

qiime tools export \
--input-path ./qza/all_classification_silva.qza \
--output-path ./export_silva

qiime tools export \
--input-path ./qza/all_silva_aligned-rep-seqs-no-mtcp.qza \
--output-path ./export_silva

### Export filtered feature table to BIOMv2 format file
qiime tools export \
--input-path ./qza/all_silva_table-no-mtcp.qza \
--output-path ./export_silva
### Convert BIOMv2 format feature table
biom convert \
-i ./export_silva/feature-table.biom \
--to-tsv \
-o ./export_silva/all_silva_feature-table.tsv

### Export rareified filtered feature table to BIOMv2 format file
qiime tools export \
--input-path ./core-metrics-results_silva/rarefied_table.qza \
--output-path ./export_silva_rare
### Convert BIOMv2 format feature table
biom convert \
-i ./export_silva_rare/feature-table.biom \
--to-tsv \
-o ./export_silva/all_silva_rarefied_feature-table.tsv

### Modify formatting of .tsv taxonomy tables
awk -F "\t" '{print $1"\t"$2}' ./export_silva/taxonomy.tsv > ./export_silva/taxonomy2.tsv
#need to insert literal tab
#sed 's/;/(ctrl + v + tab)/g' ./export/taxonomy2.tsv > ./export/taxonomy3.tsv
#grep -v "Feature" ./export/taxonomy3.tsv > ./export/taxonomy4.tsv
#need to open taxonomy4.tsv in Excel and save as tab-deliminted text

### Modify formatting of .tsv feature tables (rareified and unrareified)
sed 's/#OTU ID/ASVID/g' ./export_silva/all_silva_feature-table.tsv > ./export_silva/feature-table2.tsv
grep -v "Constructed" ./export_silva/feature-table2.tsv > ./export_silva/feature-table3.tsv
rm ./export_silva/all_silva_feature-table.tsv
rm ./export_silva/feature-table2.tsv
mv ./export_silva/feature-table3.tsv ./export_silva/all_silva_feature-table.tsv

sed 's/#OTU ID/ASVID/g' ./export_silva/all_silva_rarefied_feature-table.tsv > ./export_silva/all_rarefied_feature-table2.tsv
grep -v "Constructed" ./export_silva/all_rarefied_feature-table2.tsv > ./export_silva/all_rarefied_feature-table3.tsv
rm ./export_silva/all_silva_rarefied_feature-table.tsv
rm ./export_silva/all_rarefied_feature-table2.tsv
mv ./export_silva/all_rarefied_feature-table3.tsv ./export_silva/all_silva_rarefied_feature-table.tsv
