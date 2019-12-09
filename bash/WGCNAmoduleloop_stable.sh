#!/bin/bash
MODULES=~/computing/scripts/EAPSI.HW-WT-master/WGCNAmodules_Pdam/lists/*_ID.txt
for module in $MODULES
do
  grep -f $module ~/computing/sequences/genomes/coral/pocillopora/pdam_genome_IDs.notes.gff > ${module}_notes.txt
done
