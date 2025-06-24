# Call SNPs with bcftools and then filter #

See https://github.com/samtools/bcftools and  for more information


First index the genome with samtools
samtools v. 1.9

```
samtools faidx $GENOME
```

### bcftools ###

bcftools v. 1.13

```
bcftools mpileup -d 2000 -O u --annotate FORMAT/AD,FORMAT/DP,FORMAT/SP,INFO/AD -f $GENOME 24CM_paired_unique.sorted.bam 4C6M_paired_unique.sorted.bam 6C9M_paired_unique.sorted.bam 8C17M_paired_unique.sorted.bam rosc_paired_unique.sorted.bam | bcftools call -mv -O v -o wholegenes.vcf
```

### filter ###

Remove missing data and indels and keep only biallelic snps

vcftools v. 0.1.16

```
vcftools --vcf wholegenes.vcf --max-missing 1 --min-alleles 2 --max-alleles 2 --remove-indels --recode --recode-INFO-all --out wholegenes_ready
```
