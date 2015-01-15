#! /bin/bash
## this thing shouldn't be run in the same folder twice.
# This bad boy is a list of yer input files. But you knew that!
## query files shouldn't have blank lines in them, they match everything
files=*.txt

for file in $files
do
  # BLAHgenes.phy ---> BLAH
  prefix=`basename $file .txt`
  # search the aliases file for all instances of each gene and add it to a file named after the search
  cat ~/Bioinformatics/Arabidopsis/gene_aliases_20130130.txt | grep -f $prefix.txt >> $prefix.names.txt
   
done 