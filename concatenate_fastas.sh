#! /bin/bash

# This bad boy is a list of yer input files. But you knew that!
files=*.orthogroupmembers.fasta

for file in $files
do
  # BLAH.orthogroupmembers.fasta ---> BLAH
  prefix=`basename $file .orthogroupmembers.fasta`
  # concatenate the three fasta files generated into one suitable for alignment. 
  cat $prefix.orthogroupmembers.fasta $prefix.missingAts.fasta > $prefix.assembly.fasta
  # $prefix.missingPhysco.fasta 
done 