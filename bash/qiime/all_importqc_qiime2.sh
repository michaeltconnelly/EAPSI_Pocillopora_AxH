#!/bin/bash
#source activate qiime2-2019.1
cd /Users/mikeconnelly/computing/scripts/EAPSI-bacteria/all_wd/

### Import demultiplexed 16S sequence reads into QIIME2 environment
qiime tools import \
--input-path ./metadata/manifest_all.tsv \
--input-format PairedEndFastqManifestPhred33V2 \
--output-path ./qza/all.qza \
--type 'SampleData[PairedEndSequencesWithQuality]'

### Summarize read depth and quality scores
qiime demux summarize \
--i-data ./qza/all.qza \
--o-visualization ./qzv/all.qzv

bash ./all_dada2_qiime2.sh
