#! /bin/bash

# This bad boy is a list of yer input files. But you knew that!
files=*.tree

for file in $files
do
  # BLAHgenes.fasta ---> BLAH
  prefix=`basename $file .tree`
  # tblastx translates a nucleotide query and searches the translated database. Four databases are searched. The first search makes a results file, the others add to it.
  tblastx -db ~/Bioinformatics/Nitella_hyalina/Nitella -evalue 1E-10 -num_alignments 1 -query $file > $prefix.tblastx.txt
  tblastx -db ~/Bioinformatics/Penium_margaritaceum/Penium -evalue 1E-10 -num_alignments 1 -query $file >> $prefix.tblastx.txt
  tblastx -db ~/Bioinformatics/Spirogyra_pratensis/Spirogyra -evalue 1E-10 -num_alignments 1 -query $file >> $prefix.tblastx.txt
  tblastx -db ~/Bioinformatics/Chaetosphaeridium_globosum/Chaetosphaeridium -evalue 1E-10 -num_alignments 1 -query $file >> $prefix.tblastx.txt
done 
