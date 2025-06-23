# SRA downloads #

See https://github.com/ncbi/sra-tools for more information

### Example with *O. denselamellosa* ###

```
prefetch --max-size 100g SRR19238449 >& file.log 2>&1

fasterq-dump --split-files SRR19238449 --temp <path-to-temp-directory> >& file.log 2>&1
```
