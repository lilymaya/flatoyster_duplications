# Extracted *k*-mer comparisons #

Following flatoyster_duplications/fastk_genomescope_smudgeplot.md, the extracted *k*-mer sequences were compared between individuals.

Extract results for each individuals consist of a text file for each smudge (i.e. extracted_2C_1A1B.txt, extracted_2C_2A1B.txt, extracted_2C_3A1B.txt, extracted_2C_2A2B.txt)

(Please note that the following custom scripts were created by Nicolas Bierne)

### Create comparison table ###

First, all extracted files for all five individuals are placed into a folder (/home/hetmers). Then the following python script was run to create a comparison table:

```
import re
import csv
import subprocess
from pathlib import Path

folder = Path("/home/hetmers")
samples = ["6C", "4C", "2C", "8C", "rosc"]
file_pattern = re.compile(r"^extracted_(.+?)\.(.+?)\.txt$")
hetmer_pattern = re.compile(r"\(([ACGTacgt])/([ACGTacgt])\)")

def canonicalize_hetmer(h):
    """
    Convert a hetmer into a canonical form so that allele order
    at the variable position does not matter.
    """
    h = h.strip().lower()
    if not h:
        return None

    m = hetmer_pattern.search(h)
    if not m:
        raise ValueError(f"Unrecognized hetmer format: {h}")

    a1, a2 = sorted([m.group(1), m.group(2)])
    return h[:m.start()] + f"({a1}/{a2})" + h[m.end():]

# Temporary and output files
tmp_unsorted = folder / "tmp_hetmers_long_unsorted.tsv"
tmp_sorted = folder / "tmp_hetmers_long_sorted.tsv"
output_file = folder / "hetmer_genotypes_table.tsv"

# Step 1: create a temporary file: hetmer, sample, genotype
files_seen = 0
records_written = 0

with open(tmp_unsorted, "w", newline="") as out:
    writer = csv.writer(out, delimiter="\t")
    writer.writerow(["hetmer", "sample", "genotype"])

    for f in sorted(folder.glob("*.txt")):
        fname = f.name.strip()

        m = file_pattern.match(fname)
        if not m:
            print(f"Skipping file with unexpected name format: {fname}")
            continue

        sample = m.group(1).strip()
        genotype = m.group(2).strip()

        # sanity check for unexpected sample names
        if sample not in samples:
            print(f"Skipping file with unexpected sample name: {fname}")
            continue

        files_seen += 1

        with open(f, "r") as infile:
            for line_num, line in enumerate(infile, start=1):
                line = line.strip()
                if not line:
                    continue

                try:
                    locus = canonicalize_hetmer(line)
                except ValueError as e:
                    print(f"{fname}, line {line_num}: {e}")
                    continue

                writer.writerow([locus, sample, genotype])
                records_written += 1

print(f"{files_seen} files read")
print(f"{records_written} long-format records written")


# Step 2: sort the temporary file on disk by hetmer then sample
tmp_noheader = folder / "tmp_hetmers_long_noheader.tsv"

with open(tmp_unsorted, "r") as infile, open(tmp_noheader, "w") as out:
    next(infile)  # skip header
    for line in infile:
        out.write(line)

subprocess.run(
    ["sort", "-t", "\t", "-k1,1", "-k2,2", str(tmp_noheader), "-o", str(tmp_sorted)],
    check=True
)

print(f"Sorted temporary file written to: {tmp_sorted}")

# Step 3: rebuild the genotype table with one row per hetmer
with open(output_file, "w", newline="") as out:
    writer = csv.writer(out, delimiter="\t")
    writer.writerow(["hetmer"] + samples)

    current_hetmer = None
    current_genotypes = None
    conflicts = 0
    loci_written = 0

    with open(tmp_sorted, "r") as infile:
        for line in infile:
            hetmer, sample, genotype = line.rstrip("\n").split("\t")

            if hetmer != current_hetmer:
                if current_hetmer is not None:
                    writer.writerow([current_hetmer] + [current_genotypes[s] for s in samples])
                    loci_written += 1

                current_hetmer = hetmer
                current_genotypes = {s: "INV" for s in samples}

            old = current_genotypes[sample]
            if old == "INV":
                current_genotypes[sample] = genotype
            elif old != genotype:
                conflicts += 1

        # write last locus
        if current_hetmer is not None:
            writer.writerow([current_hetmer] + [current_genotypes[s] for s in samples])
            loci_written += 1

print(f"{loci_written} loci written to: {output_file}")
print(f"Conflicts detected: {conflicts}")
```
This script creates hetmer_genoytpes_table.tsv- a very large (~8GB) table with unique hetmers as a first column and the genotypes of the 5 individuals in the 5 next columns.

### Calculate counts of the genotype combinations ###

Run the following python script to convert the hetmer_genotypes_table.tsv into a more manageable format, showing the combinations of genotypes observed for each het-mer across the five individuals.
If the het-mer was not identified in the extracted file for the individual it is encoded as INV.

```
import csv
from pathlib import Path
from collections import Counter

input_file = Path("/home/hetmer_genotypes_table.tsv")
output_file = input_file.parent / "genotype_combination_counts.tsv"

# Counter for unordered genotype combinations
combo_counts = Counter()

with open(input_file, "r") as infile:
    reader = csv.reader(infile, delimiter="\t")
    header = next(reader)

    for row in reader:
        if not row:
            continue

        genotypes = row[1:6]

        # Sort genotypes so that individual order does not matter
        combo = tuple(sorted(genotypes))

        combo_counts[combo] += 1

# Write output
with open(output_file, "w", newline="") as out:
    writer = csv.writer(out, delimiter="\t")
    writer.writerow(["combination", "count"])

    for combo, count in combo_counts.most_common():
        writer.writerow([" ".join(combo), count])

print(f"{len(combo_counts)} different genotype combinations written to:")
print(output_file)

```
This output file is found at flatoyster_duplications/genotype_combination_counts.tsv
