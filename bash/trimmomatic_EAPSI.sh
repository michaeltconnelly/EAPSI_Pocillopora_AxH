#!/bin/bash
#~/scripts/EAPSI.HW-WT-master/trimmomatic_EAPSI.sh
#/scratch/projects/transcriptomics/mikeconnelly/scripts/EAPSI.HW-WT-master/trimmomatic_EAPSI.sh
#purpose: wrapper script to submit jobs for trimming poor-quality bases and adapter sequences from raw RNAseq reads using Trimmomatic on Pegasus bigmem queue

#BSUB -J trimmomatic_wrapper
#BSUB -q bigmem
#BSUB -P transcriptomics
#BSUB -o trimwrap%J.out
#BSUB -e trimwrap%J.err
#BSUB -n 8
#BSUB -u mconnelly@rsmas.miami.edu
#BSUB -N

#specify variable containing sequence file prefixes and directory paths
mcs="/scratch/projects/transcriptomics/mikeconnelly"
coldir="/scratch/projects/transcriptomics/mikeconnelly/sequences/EAPSI/houwanwanglitung"
exp="alltreatments"
EAPSIsamples="Wt1-1a Wt1-1b Wt1-1c Wt1-2a Wt1-2b Wt1-3a Wt1-3b Wt1-3c Wt1-4a Wt1-4b Wt1-4c Wt1-5a Wt1-5b Wt1-5c Wt1-6a Wt1-6b Wt1-6c Wt2-1a Wt2-1b Wt2-1c Wt2-2b Wt2-2c Wt2-3a Wt2-3b Wt2-3c Wt2-4a Wt2-4b Wt2-4c Wt2-5a Wt2-5b Wt2-5c Wt2-6a Wt2-6b Wt2-6c Hw1-1a Hw1-1b Hw1-1c Hw1-2a Hw1-2b Hw1-2c Hw1-3a Hw1-3b Hw1-3c Hw1-4a Hw1-4b Hw1-4c Hw1-5a Hw1-5b Hw1-5c Hw1-6a Hw1-6b Hw1-6c Hw2-1a Hw2-1b Hw2-1c Hw2-2a Hw2-2b Hw2-2c Hw2-3a Hw2-3b Hw2-3c Hw2-4a Hw2-4b Hw2-4c Hw2-5a Hw2-5b Hw2-5c Hw2-6b Hw2-6c"

#lets me know which files are being processed
echo "These are the samples to be processed:"
echo $EAPSIsamples

#loop to automate generation of scripts to direct sequence file trimming
for EAPSIsample in $EAPSIsamples
do \
echo "$EAPSIsample"

#   input BSUB commands
echo '#!/bin/bash' > "${coldir}"/"${exp}"/scripts/"${EAPSIsample}"_trimmomatic.job
echo '#BSUB -q general' >> "${coldir}"/"${exp}"/scripts/"${EAPSIsample}"_trimmomatic.job
echo '#BSUB -J '"${EAPSIsample}"_trimmomatic'' >> "${coldir}"/"${exp}"/scripts/"${EAPSIsample}"_trimmomatic.job
echo '#BSUB -o '"${coldir}"/"${exp}"/logfiles/"$EAPSIsample"trim%J.out'' >> "${coldir}"/"${exp}"/scripts/"${EAPSIsample}"_trimmomatic.job
echo '#BSUB -e '"${coldir}"/"${exp}"/errorfiles/"$EAPSIsample"trim%J.err'' >> "${coldir}"/"${exp}"/scripts/"${EAPSIsample}"_trimmomatic.job

#   input command to load modules for trimming
echo 'module load java/1.8.0_60' >> "${coldir}"/"${exp}"/scripts/"${EAPSIsample}"_trimmomatic.job
echo 'module load trimmomatic/0.36' >> "${coldir}"/"${exp}"/scripts/"${EAPSIsample}"_trimmomatic.job

#   input command to unzip raw reads before trimming
echo 'echo 'Unzipping "${EAPSIsample}"'' >> "${coldir}"/"${exp}"/scripts/"${EAPSIsample}"_trimmomatic.job
echo 'gunzip '"${coldir}"/"${exp}"/zippedreads/"${EAPSIsample}".txt.gz >> "${coldir}"/"${exp}"/scripts/"${EAPSIsample}"_trimmomatic.job

#   input command to trim raw reads
echo 'echo 'Trimming "${EAPSIsample}"'' >> "${coldir}"/"${exp}"/scripts/"${EAPSIsample}"_trimmomatic.job
echo '/share/opt/java/jdk1.8.0_60/bin/java -jar /share/apps/trimmomatic/0.36/trimmomatic-0.36.jar \
SE \
-phred33 \
-trimlog '"${coldir}"/"${exp}"/logfiles/"${EAPSIsample}"_trim.log \
"${coldir}"/"${exp}"/zippedreads/"${EAPSIsample}".txt \
"${coldir}"/"${exp}"/trimmomaticreads/"${EAPSIsample}"_trimmed.fastq.gz \
ILLUMINACLIP:"${mcs}"/programs/Trimmomatic-0.36/adapters/TruSeq3-SE.fa:2:30:10 \
LEADING:3 \
TRAILING:3 \
SLIDINGWINDOW:4:15 \
MINLEN:36 >> "${coldir}"/"${exp}"/scripts/"${EAPSIsample}"_trimmomatic.job
echo 'echo '"$EAPSIsample" trimmed''  >> "${coldir}"/"${exp}"/scripts/"${EAPSIsample}"_trimmomatic.job

#   input command to zip raw reads after trimming
echo 'gzip '"${coldir}"/"${exp}"/zippedreads/"${EAPSIsample}".txt  >> "${coldir}"/"${exp}"/scripts/"${EAPSIsample}"_trimmomatic.job

#   submit generated trimming script to job queue
bsub < "${coldir}"/"${exp}"/scripts/"${EAPSIsample}"_trimmomatic.job
done
