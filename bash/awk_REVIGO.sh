#!/bin/bash
topGOfiles=~/computing/projects/EAPSI_Pocillopora_AxH/outputs/DESeq-results/topGO/*.csv
for i in $topGOfiles; do
awk -F "," '{print $2, $9}' $i > ${i}_REVIGO.txt
done
