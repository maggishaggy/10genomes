#! /bin/bash

# This bad boy is a list of yer input files. But you knew that!
files=*.missingAts.txt

for file in $files
do
  # BLAH.missingAts.txt ---> BLAH
  prefix=`basename $file .missingAts.txt`
  # Search Arabidopsis CDS file for sequences in file
  python ~/Scripts/filter_fasta_willy.py ~/Bioinformatics/Arabidopsis/Athaliana_167_cds_primaryTranscriptOnly.fa $prefix.missingAts.txt > $prefix.missingAts.fasta
done 
