# Making a big comparison table based on SNP lists created using flatoyster_duplications/dosageclusters.R

library(tidyr)
library(dplyr)

#6C

C6_AA <- read.table("6C_AA_snps.txt", header = FALSE)
chr <- C6_AA$V1
pos <- C6_AA$V2
C6_AA_united <- data.frame(chr, pos)
C6_AA_final <- C6_AA_united %>%
  mutate(genotype=c("AA"))

C6_AB <- read.table("6C_AB_snps.txt", header = FALSE)
chr <- C6_AB$V1
pos <- C6_AB$V2
C6_AB_united <- data.frame(chr, pos)
C6_AB_final <- C6_AB_united %>%
  mutate(genotype=c("AB"))

C6_BB <- read.table("6C_BB_snps.txt", header = FALSE)
chr <- C6_BB$V1
pos <- C6_BB$V2
C6_BB_united <- data.frame(chr, pos)
C6_BB_final <- C6_BB_united %>%
  mutate(genotype=c("BB"))

C6_AAA <- read.table("6C_AAA_snps.txt", header = FALSE)
chr <- C6_AAA$V1
pos <- C6_AAA$V2
C6_AAA_united <- data.frame(chr, pos)
C6_AAA_final <- C6_AAA_united %>%
  mutate(genotype=c("AAA"))

C6_AAB <- read.table("6C_AAB_snps.txt", header = FALSE)
chr <- C6_AAB$V1
pos <- C6_AAB$V2
C6_AAB_united <- data.frame(chr, pos)
C6_AAB_final <- C6_AAB_united %>%
  mutate(genotype=c("AAB"))

C6_BBA <- read.table("6C_BBA_snps.txt", header = FALSE)
chr <- C6_BBA$V1
pos <- C6_BBA$V2
C6_BBA_united <- data.frame(chr, pos)
C6_BBA_final <- C6_BBA_united %>%
  mutate(genotype=c("BBA"))

C6_BBB <- read.table("6C_BBB_snps.txt", header = FALSE)
chr <- C6_BBB$V1
pos <- C6_BBB$V2
C6_BBB_united <- data.frame(chr, pos)
C6_BBB_final <- C6_BBB_united %>%
  mutate(genotype=c("BBB"))

C6_AAAA <- read.table("6C_AAAA_snps.txt", header = FALSE)
chr <- C6_AAAA$V1
pos <- C6_AAAA$V2
C6_AAAA_united <- data.frame(chr, pos)
C6_AAAA_final <- C6_AAAA_united %>%
  mutate(genotype=c("AAAA"))

C6_AAAB <- read.table("6C_AAAB_snps.txt", header = FALSE)
chr <- C6_AAAB$V1
pos <- C6_AAAB$V2
C6_AAAB_united <- data.frame(chr, pos)
C6_AAAB_final <- C6_AAAB_united %>%
  mutate(genotype=c("AAAB"))

C6_AABB <- read.table("6C_AABB_snps.txt", header = FALSE)
chr <- C6_AABB$V1
pos <- C6_AABB$V2
C6_AABB_united <- data.frame(chr, pos)
C6_AABB_final <- C6_AABB_united %>%
  mutate(genotype=c("AABB"))

C6_BBBA <- read.table("6C_BBBA_snps.txt", header = FALSE)
chr <- C6_BBBA$V1
pos <- C6_BBBA$V2
C6_BBBA_united <- data.frame(chr, pos)
C6_BBBA_final <- C6_BBBA_united %>%
  mutate(genotype=c("BBBA"))

C6_BBBB <- read.table("6C_BBBB_snps.txt", header = FALSE)
chr <- C6_BBBB$V1
pos <- C6_BBBB$V2
C6_BBBB_united <- data.frame(chr, pos)
C6_BBBB_final <- C6_BBBB_united %>%
  mutate(genotype=c("BBBB"))

C6_GT_all <- rbind(C6_AA_final, C6_AB_final, C6_BB_final, C6_AAA_final, C6_AAB_final, C6_BBA_final, C6_BBB_final, C6_AAAA_final, C6_AAAB_final, C6_AABB_final, C6_BBBA_final, C6_BBBB_final)

C6_GT_all_order <- C6_GT_all[order(C6_GT_all$chr, C6_GT_all$pos),]

write.table(C6_GT_all_order, sep = "\t", row.names = FALSE, "6C_GT_all.txt", quote = FALSE, col.names = FALSE)

#repeat above for all 5 individuals

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

#Now create SFS

table <- read.table("bigtable.txt", header = TRUE)

#now recode the genotypes
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

#Bar plot
library(ggplot2)

counts$total_genotype <- as.character(counts$total_genotype)
counts$total_genotype <- factor(counts$total_genotype, levels = c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"))

plot <- ggplot(counts, aes(x = total_genotype, y = n)) +
  geom_bar(stat = 'identity', fill = "#d0d0d0") +
  theme_minimal() + theme(
    axis.title.x = element_text(size = 15),
    axis.title.y = element_text(size = 15),
    axis.text.x = element_text(size = 10),
    axis.text.y = element_text(size = 10),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  )

plot + labs (x = "Site frequency", y = "n")
