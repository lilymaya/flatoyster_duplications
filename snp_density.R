### SNP DENSITY ###

library(dplyr)
library(tidyverse)

# make input dataframes #

rosc_2X <- rbind(roscAA, roscAB, roscBB)

rosc_2X_df <- data.frame(rosc_2X$Chromosome, rosc_2X$Position)

#add a column of numbers to be the SNP number
rosc_2X_df$SNP <- 1:nrow(rosc_2X_df)

#change chr names to just numbers
rosc_2X_df$Chromosome[rosc_2X_df$Chromosome == "Chr1"] <- "1"
rosc_2X_df$Chromosome[rosc_2X_df$Chromosome == "Chr2"] <- "2"
rosc_2X_df$Chromosome[rosc_2X_df$Chromosome == "Chr3"] <- "3"
rosc_2X_df$Chromosome[rosc_2X_df$Chromosome == "Chr4"] <- "4"
rosc_2X_df$Chromosome[rosc_2X_df$Chromosome == "Chr5"] <- "5"
rosc_2X_df$Chromosome[rosc_2X_df$Chromosome == "Chr6"] <- "6"
rosc_2X_df$Chromosome[rosc_2X_df$Chromosome == "Chr7"] <- "7"
rosc_2X_df$Chromosome[rosc_2X_df$Chromosome == "Chr8"] <- "8"
rosc_2X_df$Chromosome[rosc_2X_df$Chromosome == "Chr9"] <- "9"
rosc_2X_df$Chromosome[rosc_2X_df$Chromosome == "Chr10"] <- "10"

# change class of columns so CMplot runs properly #
rosc_2X_df$Chromosome <- as.numeric(rosc_2X_df$Chromosome)
rosc_2X_df$Position <- as.numeric(rosc_2X_df$Position)
rosc_2X_df$numbers <- as.character(rosc_2X_df$numbers)

# run CMplot #

library("CMplot")

CMplot(readydf, plot.type = "d", bin.size = 1e5, chr.den.col = c("grey93", "darkblue"))
