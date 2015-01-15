#! /bin/bash

# This bad boy is a list of yer input files. But you knew that!
files=*.tree

#Make a title line for the count file
 echo "Species" '\t' "Physcomitrella" '\t' "Arabidopsis" '\t' "Oryza sativa" '\t' "Sorghum bicolor" '\t' "Medicago truncatula" '\t' "Vitis vinifera" '\t' "Carica papaya" '\t' "Populus trichocarpa" '\t' "Chlamydomonas reinhardtii" '\t' "Selaginella moellendorffii" >> count.txt

for file in $files
do
  # BLAHgenes.phy ---> BLAH
  prefix=`basename $file .tree`
  # search file for lines containing "Phypa" or "Pp" and count them, assign number to variable "physco"
  #physco=$(cat $file | awk '$1 ~ /Phypa/ || $1 ~ /Pp/ {print}' | grep -c P)
  # search file for lines containing AT number, recognize with regular expression, count them, assign number to variable "arabi"
  #arabi=$(cat $file | awk '$1 ~ /AT[0-9]G/ {print}' | grep -c AT)
  physco=$(cat $file | grep -c Pp)
  arabi=$(cat $file | grep -c AT)
  orysa=$(cat $file | grep -c Orysa)
  sorbi=$(cat $file | grep -c Sorbi)
  medtr=$(cat $file | grep -c Medtr)
  vitvi=$(cat $file | grep -c Vitvi)
  carpa=$(cat $file | grep -c Carpa)
  poptr=$(cat $file | grep -c Poptr)
  chlre=$(cat $file | grep -c Chlre)
  selmo=$(cat $file | grep -c Selmo)
  # make output file with counts in it. 'print' and 'cat' were wrong choices. >> appends to file
   echo $prefix '\t' $physco '\t' $arabi '\t' $orysa '\t' $sorbi '\t' $medtr '\t' $vitvi '\t' $carpa '\t' $poptr '\t' $chlre '\t' $selmo >> count.txt
done