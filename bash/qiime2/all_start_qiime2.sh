#!/bin/bash
#purpose: create directory structure, copy program binaries and reference sequences on local computer
#conda activate qiime2-2019.10

prodir="/Users/mikeconnelly/computing/projects/EAPSI_Pocillopora_AxH"
exp="AxH"
EAPSIsamples="Wt1-1a Wt1-1b Wt1-1c Wt1-4a Wt1-4b Wt1-4c Wt1-5a Wt1-5b Wt1-5c Wt1-6a Wt1-6b Wt1-6c Wt2-1a Wt2-1b Wt2-1c Wt2-4a Wt2-4b Wt2-4c Wt2-5a Wt2-5b Wt2-5c Wt2-6a Wt2-6b Wt2-6c Hw1-1a Hw1-1b Hw1-1c Hw1-4a Hw1-4b Hw1-4c Hw1-5a Hw1-5b Hw1-5c Hw1-6a Hw1-6b Hw1-6c Hw2-1a Hw2-1b Hw2-1c Hw2-4a Hw2-4b Hw2-4c Hw2-5a Hw2-5b Hw2-5c Hw2-6b Hw2-6c"
echo "Pipeline setup process started"

#make file structure for pipeline file input/output
mkdir ${prodir}/outputs/qiime2
mkdir ${prodir}/outputs/qiime2/qza
mkdir ${prodir}/outputs/qiime2/qzv
mkdir ${prodir}/outputs/qiime2/QC
mkdir ${prodir}/outputs/qiime2/export_silva

bash ${prodir}/bash/qiime2/all_importqc_qiime2.sh
