#EAPSI_Pocillopora_AxH.r
#author: "Mike Connelly"
#date: "12/09/2019"

# DESeq2 ------------------------------------------------------------------

library("tidyverse")
library("DESeq2")
library("ggpubr")
library("apeglm")

#Import sample data
stable_samples <- read.table("./data/EAPSIsamples_stable.txt", header = TRUE)
#Import counts data
countdata <- read.delim("AxH_Pdam.counts", row.names = 1, skip = 1)

