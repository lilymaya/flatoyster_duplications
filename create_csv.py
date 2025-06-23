import csv
import vcf

# path to the vcf file
vcf_file_path = "<path-to-directory>/6C9M.recode.vcf"

# path for the output csv file
output_file_path = "<output-directory>/6C9M_all.csv"

# read the vcf file with vcf_reader
vcf_reader = vcf.Reader(open(vcf_file_path, 'r'))

# make the csv file
with open(output_file_path, 'w', newline='') as csv_file:
    # csv writer
    csv_writer_all = csv.writer(csv_file)

    # header for csv
    csv_writer_all.writerow([
        "Chromosome", "Position", "Ref Count", "Alt Count", 
        "Total Alleles", "Alt Frequency", "Genotype"
    ])

    # go over every SNP
    for record in vcf_reader:
        # record information for each snp
        chrom = record.CHROM
        pos = record.POS

        # count number of reference and alternative alleles
        sample = record.samples[0]
        ref_count = sample.data.AD[0]
        alt_count = sample.data.AD[1]

        # total alleles
        total_alleles = ref_count + alt_count

        # freq of alternative allele
        if total_alleles != 0:
            alt_frequency = alt_count / total_alleles
        else:
            alt_frequency = 0.0

        # GT field in vcf file
        genotype = sample.data.GT

        # write into csv
        csv_writer_all.writerow([
            chrom, pos, ref_count, alt_count, 
            total_alleles, alt_frequency, genotype
        ])
