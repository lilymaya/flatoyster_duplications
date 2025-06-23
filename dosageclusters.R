### Gene dosage clusters ###

library(dplyr)
library(tidyverse)
library(ggplot2)

#file
file <- read.csv("2C4M_all.csv", header = TRUE)

#Keep only the Chr entries

filtered_data1 <- file %>%
  filter(Chromosome == "Chr1")
filtered_data2 <- file %>%
  filter(Chromosome == "Chr2")
filtered_data3 <- file %>%
  filter(Chromosome == "Chr3")
filtered_data4 <- file %>%
  filter(Chromosome == "Chr4")
filtered_data5 <- file %>%
  filter(Chromosome == "Chr5")
filtered_data6 <- file %>%
  filter(Chromosome == "Chr6")
filtered_data7 <- file %>%
  filter(Chromosome == "Chr7")
filtered_data8 <- file %>%
  filter(Chromosome == "Chr8")
filtered_data9 <- file %>%
  filter(Chromosome == "Chr9")
filtered_data10 <- file %>%
  filter(Chromosome == "Chr10")

file_chr <- rbind(filtered_data1,filtered_data2,filtered_data3,filtered_data4,filtered_data5,filtered_data6,filtered_data7,filtered_data8,filtered_data9,filtered_data10)

#Good SNPs (between 1 and 5X)
Good <- file_chr %>%
  filter((Total.Alleles > 168.5 & Total.Alleles <= 842.5))

#####     define clusters     #####

##### AA
AA <- file_chr %>%
  filter((Total.Alleles > 252.75 & Total.Alleles <= 421.25) &
           (Alt.Frequency <= 0.1))

##### BB
BB <- file_chr %>%
  filter((Total.Alleles > 252.75 & Total.Alleles <= 421.25) &
           (Alt.Frequency >= 0.9))
##### AB
AB <- file_chr %>%
  filter((Total.Alleles > 252.75 & Total.Alleles <= 421.25) &
           (Alt.Frequency >= 0.4 & Alt.Frequency <= 0.6))

##### AAA
AAA <- file_chr %>%
  filter((Total.Alleles > 421.25 & Total.Alleles <= 589.75) &
           (Alt.Frequency <= 0.1))

##### AAB
AAB <- file_chr %>%
  filter((Total.Alleles > 421.25 & Total.Alleles <= 589.75) &
           (Alt.Frequency >= 0.25 & Alt.Frequency <= 0.4))

###### BBA
BBA <- file_chr %>%
  filter((Total.Alleles > 421.25 & Total.Alleles <= 589.75) &
           (Alt.Frequency >= 0.6 & Alt.Frequency <= 0.75))

##### BBB
BBB <- file_chr %>%
  filter((Total.Alleles > 421.25 & Total.Alleles <= 589.75) &
           (Alt.Frequency >= 0.9))

##### AAAA
AAAA <- file_chr %>%
  filter((Total.Alleles > 311.5 & Total.Alleles <= 400.5) &
           (Alt.Frequency <= 0.1))

##### AAAB
AAAB <- file_chr %>%
  filter((Total.Alleles > 589.75 & Total.Alleles <= 758.25) &
           (Alt.Frequency >= 0.2 & Alt.Frequency <= 0.33))

##### AABB
AABB <- file_chr %>%
  filter((Total.Alleles > 589.75 & Total.Alleles <= 758.25) &
           (Alt.Frequency >= 0.4 & Alt.Frequency <= 0.6))

##### BBBA
BBBA <- file_chr %>%
  filter((Total.Alleles > 589.75 & Total.Alleles <= 758.25) &
           (Alt.Frequency >= 0.66 & Alt.Frequency <= 0.8))

##### BBBB
BBBB <- file_chr %>%
  filter((Total.Alleles > 589.75 & Total.Alleles <= 758.25) &
           (Alt.Frequency >= 0.9))
