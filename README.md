# flatoyster_duplications
Code used for project ***k*-mer spectra and allelic coverage analyses reveal pervasive polymorphic duplications in Ostrea edulis** (Colston-Nepali, Lapègue and Bierne) submitted to PCI Genomics.

### How to follow ###
First we download publicly available datasets: [*sra_downloads.md*](https://github.com/lilymaya/flatoyster_duplications/blob/main/sra_downloads.md)

Then we use *k*-mer based analyses: [*fastk_genomescope_smudgeplot.md*](https://github.com/lilymaya/flatoyster_duplications/blob/main/fastk_genomescope_smudgeplot.md)

Extracted smudges are compared between individuals: [*compare_extracted_kmers.md*](https://github.com/lilymaya/flatoyster_duplications/blob/main/compare_extracted_kmers.md)

Final het-mer combination counts: [*genotype_combination_counts.tsv*](https://github.com/lilymaya/flatoyster_duplications/blob/main/genotype_combination_counts.tsv)

Trim raw sequence files and map to reference genome: [*trim_and_map.md*](https://github.com/lilymaya/flatoyster_duplications/blob/main/trim_and_map.md)

Call SNPs and filter: [*call_snps_and_filter.md*](https://github.com/lilymaya/flatoyster_duplications/blob/main/call_snps_and_filter.md)

Custom python script to extract allele counts: [*create_csv.py*](https://github.com/lilymaya/flatoyster_duplications/blob/main/create_csv.py)

R script to define dosage inferred clusters: [*dosageclusters.R*](https://github.com/lilymaya/flatoyster_duplications/blob/main/dosageclusters.R)

R script to create comparison table between individuals for DI genotypes identified at each SNP: [*comparison_table_SNPs.R*](https://github.com/lilymaya/flatoyster_duplications/blob/main/comparison_table_SNPs.R)

Final comparison table for DI genotype at each SNP for each individual: [*bigtable.zip*](https://github.com/lilymaya/flatoyster_duplications/blob/main/bigtable.zip)

Use SnpEff to annotate vcfs, and examine GO enrichment: [*snpeff.md*](https://github.com/lilymaya/flatoyster_duplications/blob/main/snpeff.md)
