# Trim and map #

See https://github.com/OpenGene/fastp, https://github.com/lh3/bwa and https://github.com/biod/sambamba for more info

### Trim with fastp ###

fastp v. 0.20.0 

Example with sample 6C9M
```
fastp -i 6-C9M_S5ds_R1_001.fastq.gz -I 6-C9M_S5ds_R2_001.fastq.gz -o $DATAOUTPUT/6-C9M_S5_paired_1.fastq.gz  -O $DATAOUTPUT/6-C9M_S5_paired_2.fastq.gz --adapter_fasta $ADAPTERFILE --trim_poly_g --average_qual 28 --length_required 50 --thread 28 &> $LOG/fastp_6-9CM_S5.log

```

### Map to reference genome using BWA-MEM ###

bwa-mem v. 0.7.17 sambamba v. 0.8.0

Make array table
```
cd $DATAINPUT
basename -s _paired_1.fastq.gz *_paired_1.fastq.gz > $DATADIRECTORY/00_scripts/base_map.txt
NAME=$(cat $DATADIRECTORY/00_scripts/base_map.txt | awk "NR==${PBS_ARRAY_INDEX}")

#save array table correspondance
echo -e ${PBS_ARRAY_INDEX}"\t"${NAME} >> $DATADIRECTORY/00_scripts/04a_map_array_table.txt

```

Index genome
```
bwa index $GENOME
```

Map
```
bwa mem -t 15 -M $GENOME -R '@RG\tID:'${NAME}'\tSM:'${NAME}'\tPL:illumina\tLB:lib1\tPU:unit1' ${NAME}_paired_1.fastq.gz ${NAME}_paired_2.fastq.gz > $DATAOUTPUT/${NAME}.sam
```

Filter output files and convert to bam format using SAMBAMBA
```
sambamba view -t 15 -S -f bam ${NAME}.sam > ${NAME}.bam
rm ${NAME}.sam
sambamba view -f bam -F "proper_pair and not (unmapped or secondary_alignment) and not ([XA] != null or [SA] != null)" ${NAME}.bam > ${NAME}_paired_unique.bam
rm ${NAME}.bam
sambamba sort ${NAME}_paired_unique.bam
rm ${NAME}_paired_unique.bam
sambamba index -t 15 ${NAME}_paired_unique.sorted.bam
```
