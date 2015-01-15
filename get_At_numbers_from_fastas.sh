#! /bin/bash

# This bad boy is a list of yer input files. But you knew that!
files=*genes.fa

for file in $files
do
  # BLAHgenes.fa ---> BLAH
  prefix=`basename $file genes.fa`
  # perl -e YOUR_CRAP < BLAHgenes.fa > /generic_directory/BLAH.txt
  perl -e 'while(<>){if(/^>(\w+)/){print "$1\n";}}' < $file > $prefix.txt
  # ^ what is this perl blob doing exactly? grabbing the first field in each
  # line?
done
