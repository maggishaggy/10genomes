#! /bin/bash

# This bad boy is a list of yer input files. But you knew that!
files=*.family.txt

for file in $files
do
  # BLAHgenes.fa ---> BLAH
  prefix=`basename $file .family.txt`
  ~/bin/blastdbcmd -db ~/Dropbox/Bioinformaticscollaboration/10_genomesdatabase/10_genomes.cds -entry_batch $file -out $prefix.orthogroupmembers.fasta -dbtype nucl
done 