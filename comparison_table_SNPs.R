### Making a big comparison table based on SNP lists created using flatoyster_duplications/dosageclusters.R ###

library(tidyr)
library(dplyr)

#Combine all SNP lists output from dosageclusters.R for each individual, i.e. 6C:
#Read in each list and create a column to identify the DI genotype (ie. AA)
C6_AA <- read.table("6C_AA_snps.txt", header = FALSE)
chr <- C6_AA$V1
pos <- C6_AA$V2
C6_AA_united <- data.frame(chr, pos)
C6_AA_final <- C6_AA_united %>%
  mutate(genotype=c("AA"))

#repeat the above for each of the 12 DI genotypes
#then combine these dataframes, reorder and make a table

C6_GT_all <- rbind(C6_AA_final, C6_AB_final, C6_BB_final, C6_AAA_final, C6_AAB_final, C6_BBA_final, C6_BBB_final, C6_AAAA_final, C6_AAAB_final, C6_AABB_final, C6_BBBA_final, C6_BBBB_final)

C6_GT_all_order <- C6_GT_all[order(C6_GT_all$chr, C6_GT_all$pos),]

write.table(C6_GT_all_order, sep = "\t", row.names = FALSE, "6C_GT_all.txt", quote = FALSE, col.names = FALSE)

#Repeat above for all 5 individuals

#Next, merge all files

library(dplyr)
library(purrr)

C6 <- read.table("6C_GT_all.txt", header = FALSE)
C4 <- read.table("4C_GT_all.txt", header = FALSE)
C2 <- read.table("2C_GT_all.txt", header = FALSE)
C8 <- read.table("8C_GT_all.txt", header = FALSE)
rosc <- read.table("rosc_GT_all.txt", header = FALSE)

colnames(C6) <- c("Chromosome", "Position", "Genotype_6C")
colnames(C4) <- c("Chromosome", "Position", "Genotype_4C")
colnames(C2) <- c("Chromosome", "Position", "Genotype_2C")
colnames(C8) <- c("Chromosome", "Position", "Genotype_8C")
colnames(rosc) <- c("Chromosome", "Position", "Genotype_rosc")

merged <- reduce(
  list(C6, C4, C2, C8, rosc),
  full_join,
  by = c("Chromosome", "Position")
)

#Make sure in the right order
filtered_order <- filtered[order(filtered$Chromosome, filtered$Position),]

write.table(filtered_order, sep = "\t", row.names = FALSE, "bigtable.txt", quote = FALSE, col.names = TRUE)

### finally, create SFS ###

table <- read.table("bigtable.txt", header = TRUE)

#now recode the genotypes (0 for 2X, 1 for 3X, 2 for 4X)
geno_cols <- grep("^Genotype_", names(table))

table[, geno_cols] <-
  lapply(table[, geno_cols],
         function(x) ifelse(is.na(x), NA, nchar(x) - 2))

#add totals
geno_cols <- grep("^Genotype_", names(table), value = TRUE)

recoded <- table %>%
  mutate(total_genotype = rowSums(across(all_of(geno_cols)), 
                                  na.rm = FALSE))
counts <- recoded %>%
  count(total_genotype) %>%
  arrange(total_genotype)
