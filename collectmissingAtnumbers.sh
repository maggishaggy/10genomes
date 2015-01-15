#! /bin/bash

# This bad boy is a list of yer input files. But you knew that!
files=*.family.txt

for file in $files
do
  # BLAHgenes.family.txt ---> BLAH
  prefix=`basename $file .family.txt`
  # Identify all the Arabidopsis At numbers sorted into orthogroups
  cat $prefix.family.txt | grep Arath | cut -c 12- > foundAts.txt
  # Search original list of At numbers for members NOT in foundAts.txt
  cat $prefix.txt | grep -v -f foundAts.txt > $prefix.missingAts.txt
  # clean up the foundAts.txt file
  rm foundAts.txt
done 
