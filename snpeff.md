# SnpEff

SnpEff v. 5.0

See https://pcingola.github.io/SnpEff/snpeff/introduction/ for more information

### First build a database ###

Database built following instructions here: https://pcingola.github.io/SnpEff/snpeff/build_db/

Followed step 2, option 3 with my reference genome (Li et al. 2022)

```
java -jar snpEff.jar build -gff3 -v Oed
```
### Then run the annotation on each file
```
java -Xmx8g -jar snpEff.jar -v Oed rosc_2X.recode.vcf > rosc_2X.ann.vcf
```

### Update: GO enrichment analysis for chromosomes 6, 7, 8
Example below for chr6

First annotate using SnpEff
```
java -Xmx8g -jar snpEff.jar -v Oed chr6.recode.vcf > chr6.ann.vcf
```
Look at snpEff_genes.txt output file. Manually create a text file with list of genes (TranscriptId column).
Next use seqtk (see https://github.com/lh3/seqtk for more details) to extract fastq sequences for these genes.
```
seqtk subseq Oed.longest.gene.pep.fq genelist_chr6.txt > chr6.fq
```
Convert back to fasta
```
seqtk seq -a chr6.fq > chr6.fasta
```
Use these fasta files for input for KOBAS: http://bioinfo.org/kobas/genelist/
