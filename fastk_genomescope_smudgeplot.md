# FastK, GenomeScope 2.0 and Smudgeplot #

See https://github.com/thegenemyers/FASTK and https://github.com/KamilSJaron/smudgeplot for more information

Smudgeplot v. 0.3.0

### Example with *O. denselamellosa* ###

FastK with *k*-mer count of 21
```
FastK -v -t4 -k21 -M16 -T8 SRR19238449_[12].fastq -N/<path-to-output-directory>/FastK_Table -P<path-to-temp-directory> 
```

Transform for GenomeScope
```
Histex -G FastK_Table > fastk_oden_k21.hist
```

Extract *k*-mer pairs from FastK database
```
smudgeplot.py hetmers -L 8 -t 4 -o kmerpairs_L8 --verbose FastK_Table -tmp <path-to-temp-directory>
```

Generate Smudgeplot
```
smudgeplot.py all -cov_min 5 -cov_max 50 -o oden_k21_L8_cov5-50 kmerpairs_L8_text.smu
```

### Update ###

Updated Smudgeplot (v. 0.5.4) allows for extraction of *k*-mer pair sequences for each smudge. This step was run on the five main individuals. Smudgeplot all was re-run to produce the new .sma files. Example below for individual 4C
```
smudgeplot.py all -cov_min 50 -cov_max 110 -o 4C_k21_L35_cov50-110 kmerpairs35.smu
smudgeplot.py extract FastK_Table 4C_k21_L35_cov50-110 -o extracted_4C -tmp <path-to-temp-directory>

```
