# EAPSI_Pocillopora_AxH

This repository contains scripts for analyzing RNA-seq and 16S rRNA gene amplicon sequences from *Pocillopora damicornis* and *Pocillopora acuta* coral fragments subjected to an antibiotics treatment, a heat stress treatment, and a combined antibiotics plus heat stress treatment.

Unix bash scripts for analysis of coral RNAseq data on the University of Miami's Pegasus computing cluster are contained within the directory bash/rnaseq/.

`verbatim code chunk for RNAseq`

The tag-based RNAseq and gene ontology enrichment analyses conducted here are based on code from Misha Matz's [tag-based_RNAseq](http://github.com/z0on/tag-based_RNAseq) and [GO_MWU](http://github.com/z0on/GO_MWU) repositories, which have been modified and internalized for this specific project.

Raw Illumina sequence data associated with this project is available from NCBI: BioProject accession [PRJNA####](https://www.ncbi.nlm.nih.gov/sra/PRJNA#######); SRA accession [SRA#######](https://www.ncbi.nlm.nih.gov/Traces/study/?acc=SRP#####).

Scripts for analysis of bacteria 16S sequences using QIIME2 on a local machine are contained within bash/qiime2.

Change absolute paths to sequence read files in ./data/qiime2_manifest.tsv file

`source activate qiime2-2019.10
bash ./bash/qiime2/all_start_qiime2.sh`

![](./figures/AxH_Treatments.png)