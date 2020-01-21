#!/bin/bash
dir="/Users/mikeconnelly/computing/projects/EAPSI_Pocillopora_AxH"

for file in ${dir}/outputs/DESeq-results/tables/all/*
do
awk -F "," '{print $1}' ${file} > ${file}_ID.txt
sed -i '' 1d ${file}_ID.txt
sed -i -e 's/"//g' ${file}_ID.txt
rm ${file}_ID.txt-e
done
mv ${dir}/outputs/DEseq-results/tables/all/*.txt ${dir}/outputs/DEseq-results/lists/

for file in ${dir}/outputs/DESeq-results/tables/up/*
do
awk -F "," '{print $1}' ${file} > ${file}_ID.txt
sed -i '' 1d ${file}_ID.txt
sed -i -e 's/"//g' ${file}_ID.txt
rm ${file}_ID.txt-e
done
mv ${dir}/outputs/DEseq-results/tables/up/*.txt ${dir}/outputs/DEseq-results/lists/

for file in ${dir}/outputs/DESeq-results/tables/down/*
do
awk -F "," '{print $1}' ${file} > ${file}_ID.txt
sed -i '' 1d ${file}_ID.txt
sed -i -e 's/"//g' ${file}_ID.txt
rm ${file}_ID.txt-e
done
mv ${dir}/outputs/DEseq-results/tables/down/*.txt ${dir}/outputs/DEseq-results/lists/

for file in ${dir}/outputs/DESeq-results/tables/overall/*
do
awk -F "," '{print $1}' ${file} > ${file}_ID.txt
sed -i '' 1d ${file}_ID.txt
sed -i -e 's/"//g' ${file}_ID.txt
rm ${file}_ID.txt-e
done
mv ${dir}/outputs/DEseq-results/tables/overall/*.txt ${dir}/outputs/DEseq-results/lists/
