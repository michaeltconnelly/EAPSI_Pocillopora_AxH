#!/bin/bash
dir="/Users/mikeconnelly/computing/projects/EAPSI_Pocillopora_AxH"

awk -F "," '{print $1}' ${dir}/outputs/DESeq-results/tables/overall/res_AxH_ctrl.csv > ${dir}/outputs/DESeq-results/lists/res_AxH_ctrl_ID.txt
sed -i '' 1d ${dir}/outputs/DESeq-results/lists/res_AxH_ctrl_ID.txt
sed -i -e 's/"//g' ${dir}/outputs/DESeq-results/lists/res_AxH_ctrl_ID.txt
rm ${dir}/outputs/DESeq-results/lists/res_AxH_ctrl_ID.txt-e

awk -F "," '{print $1}' ${dir}/outputs/DESeq-results/tables/up/res_AxH_ctrl_up.csv > ${dir}/outputs/DESeq-results/lists/res_AxH_ctrl_up_ID.txt
sed -i '' 1d ${dir}/outputs/DESeq-results/lists/res_AxH_ctrl_up_ID.txt
sed -i -e 's/"//g' ${dir}/outputs/DESeq-results/lists/res_AxH_ctrl_up_ID.txt
rm ${dir}/outputs/DESeq-results/lists/res_AxH_ctrl_up_ID.txt-e

awk -F "," '{print $1}' ${dir}/outputs/DESeq-results/tables/down/res_AxH_ctrl_dn.csv > ${dir}/outputs/DESeq-results/lists/res_AxH_ctrl_dn_ID.txt
sed -i '' 1d ${dir}/outputs/DESeq-results/lists/res_AxH_ctrl_dn_ID.txt
sed -i -e 's/"//g' ${dir}/outputs/DESeq-results/lists/res_AxH_ctrl_dn_ID.txt
rm ${dir}/outputs/DESeq-results/lists/res_AxH_ctrl_dn_ID.txt-e
