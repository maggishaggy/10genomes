#! /bin/bash

# This bad boy is a list of yer input files. But you knew that!
files=*.missingAts.txt

for file in $files
do
  # BLAHgenes.fa ---> BLAH
  prefix=`basename $file .missingAts.txt`
  ~/bin/blastdbcmd -db ~/Bioinformatics/Arabidopsis/Arabidopsiscds -entry_batch $file -out $prefix.missingAts.fasta -dbtype nucl
  #This calls the blast database command to search the Arabidopsis coding sequence database from phytozome for all the members of each file and puts them out in a fasta file named after the input.
done 
