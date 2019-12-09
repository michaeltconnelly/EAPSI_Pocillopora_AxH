#!/bin/bash
#./bash/STARalignwrapper_Pdam_v2.sh
#purpose: align trimmed RNAseq reads against the Pocillopora damicornis genome using STAR on the Pegasus bigmem queue
#version 2: two-pass alignment for improved splice junction detection accuracy, downstream SNP calling and phylotranscriptomics, output non-aligning reads for Symbiodinaceae analysis
#To start this job from the EAPSI_Pocillopora_AxH directory, use:
#bsub -P transcriptomics < /scratch/projects/transcriptomics/mikeconnelly/projects/EAPSI_Pocillopora_AxH/bash/STARalignwrapper_Pdam_v2.sh

#BSUB -J starwrap_pdam
#BSUB -q general
#BSUB -P transcriptomics
#BSUB -o STARwrap_pdam%J.out
#BSUB -e STARwrap_pdam%J.err
#BSUB -n 8
#BSUB -u m.connelly1@umiami.edu

#specify variable containing sequence file prefixes and directory paths
mcs="/scratch/projects/transcriptomics/mikeconnelly"
prodir="/scratch/projects/transcriptomics/mikeconnelly/projects/EAPSI_Pocillopora_AxH"
exp="AxH"
EAPSIsamples="Wt1-1a Wt1-1b Wt1-1c Wt1-4a Wt1-4b Wt1-4c Wt1-5a Wt1-5b Wt1-5c Wt1-6a Wt1-6b Wt1-6c Wt2-1a Wt2-1b Wt2-1c Wt2-4a Wt2-4b Wt2-4c Wt2-5a Wt2-5b Wt2-5c Wt2-6a Wt2-6b Wt2-6c Hw1-1a Hw1-1b Hw1-1c Hw1-4a Hw1-4b Hw1-4c Hw1-5a Hw1-5b Hw1-5c Hw1-6a Hw1-6b Hw1-6c Hw2-1a Hw2-1b Hw2-1c Hw2-4a Hw2-4b Hw2-4c Hw2-5a Hw2-5b Hw2-5c Hw2-6b Hw2-6c"

#lets me know which files are being processed
echo "These are the reads to be aligned to the Pocillopora reference genome: $EAPSIsamples"

#loop to automate generation of scripts to direct sequence file trimming
for EAPSIsample in $EAPSIsamples
do \
echo "Aligning ${EAPSIsample}"

#   input BSUB commands
echo '#!/bin/bash' > "${prodir}"/bash/jobs/"${EAPSIsample}"_staralign_pdam.job
echo '#BSUB -q bigmem' >> "${prodir}"/bash/jobs/"${EAPSIsample}"_staralign_pdam.job
echo '#BSUB -J '"${EAPSIsample}"_staralign_pdam'' >> "${prodir}"/bash/jobs/"${EAPSIsample}"_staralign_pdam.job
echo '#BSUB -o '"${prodir}"/outputs/logfiles/"$EAPSIsample"staralign_pdam%J.out'' >> "${prodir}"/bash/jobs/"${EAPSIsample}"_staralign_pdam.job
echo '#BSUB -e '"${prodir}"/outputs/errorfiles/"$EAPSIsample"staralign_pdam%J.err'' >> "${prodir}"/bash/jobs/"${EAPSIsample}"_staralign_pdam.job
echo '#BSUB -n 8' >> "${prodir}"/bash/jobs/"${EAPSIsample}"_staralign_pdam.job
echo '#BSUB -W 4:00' >> "${prodir}"/bash/jobs/"${EAPSIsample}"_staralign_pdam.job

#   input command to run STAR aligner
echo ${mcs}/programs/STAR-2.5.3a/bin/Linux_x86_64/STAR \
--runMode alignReads \
--quantMode TranscriptomeSAM \
--runThreadN 16 \
--readFilesIn ${prodir}/outputs/trimmomaticreads/${EAPSIsample}_trimmed.fastq.gz \
--readFilesCommand gunzip -c \
--genomeDir ${mcs}/sequences/genomes/coral/pocillopora/STARindex \
--sjdbGTFfeatureExon exon \
--sjdbGTFtagExonParentTranscript Parent \
--sjdbGTFfile  ${mcs}/sequences/genomes/coral/pocillopora/pdam_genome.gff \
--twopassMode Basic \
--twopass1readsN -1 \
--outStd Log BAM_Unsorted BAM_Quant \
--outSAMtype BAM Unsorted \
--outReadsUnmapped Fastx \
--outFileNamePrefix ${prodir}/outputs/STARalign_Pdam/${EAPSIsample}_Pdam >> "${prodir}"/bash/jobs/"${EAPSIsample}"_staralign_pdam.job

#lets me know file is done
echo 'echo' "STAR alignment of $EAPSIsample complete"'' >> "${prodir}"/bash/jobs/"${EAPSIsample}"_staralign_pdam.job
echo "STAR alignment script of $EAPSIsample submitted"
#   submit generated trimming script to job queue
bsub < "${prodir}"/bash/jobs/"${EAPSIsample}"_staralign_pdam.job
done
