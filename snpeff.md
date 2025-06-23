# SnpEff

See https://pcingola.github.io/SnpEff/snpeff/introduction/ for more information

### First build a database ###

Database built following instructions here: https://pcingola.github.io/SnpEff/snpeff/build_db/

Followed step 2, option 3 with my reference genome (Li et al. 2022)

```
java -jar snpEff.jar build -gff3 -v Oed
```
### Then run the annotation on each file

java -Xmx8g -jar snpEff.jar -v Oed rosc_2X.recode.vcf > rosc_2X.ann.vcf
