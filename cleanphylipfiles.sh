#! /bin/bash

# This bad boy is a list of yer input files. But you knew that!
files=*.phy

for file in $files
do
  # BLAHgenes.phy ---> BLAH
  prefix=`basename $file .phy`
  # Make working copies of files
  cp $prefix.phy ./$prefix.txt
  # Take the phylip alignment files, change colons to equals, delete the "gnl|" preceding sequence IDs
  cat $prefix.txt | tr ':' '=' | sed -e 's/gnl|//g' > $prefix.phy
  # clean up
  rm $prefix.txt
 
done 