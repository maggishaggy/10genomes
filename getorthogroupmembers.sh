#! /bin/bash

# This bad boy is a list of yer input files. But you knew that!
files=*.txt

for file in $files
do
  # BLAHgenes.fa ---> BLAH
  prefix=`basename $file .txt`
  # calls Loren's perl script using each file as the search term for the 10_genomes database. The script has been modified to ignore species requirements, and the output is named after the input file
  perl ~/Dropbox/Bioinformaticscollaboration/scriptsfromLoren20130304/ortho_fasta_find.pl $file ~/Dropbox/Bioinformaticscollaboration/scriptsfromLoren20130304/10_genomes.ortho.txt Arath $prefix.family.txt
done
