#!/bin/bash
topGOfiles=~/computing/scripts/EAPSI.HW-WT-master/DESEqresults_Pdam/topGO/*.csv
for i in $topGOfiles; do
awk -F "," '{print $2, $9}' $i > ${i}_REVIGO.txt
done
