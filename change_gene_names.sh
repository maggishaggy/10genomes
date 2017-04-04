#! /bin/bash

# This bad boy is a list of yer input files. But you knew that!
files=*.tree

for file in $files
do
  # BLAHgenes.tree ---> BLAH
  prefix=`basename $file .tree`
  # -e flag allows multiple commands. s/ means substitution. /g means global, goes all the way through the line
  cat $file | sed -f ~/Scripts/phylogenetics_paper/cleantreenames.sed > $prefix.cleaned.tree
done
