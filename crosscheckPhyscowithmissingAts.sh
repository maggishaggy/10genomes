#! /bin/bash

# This bad boy is a list of yer input files. But you knew that!
files=*.missingAts.fasta

for file in $files
do
  # BLAH.missingAts.fasta ---> BLAH
  prefix=`basename $file .missingAts.fasta`
  # tBLASTx Physcomitrella genome with the missing Arabidopsis genes and take the best match for each gene if it exceeds the quality threshold
  # output is in tabular format and fed to awk script that takes column 2 (the physco id) and prepares it for the samtools index of the Physco CDS fasta
  tblastx -query $prefix.missingAts.fasta -db ~/Bioinformatics/Physcomitrella/Blast_database/Ppatens_152_cds_primaryTranscriptOnly -evalue 1E-10 -matrix BLOSUM62 -best_hit_score_edge 0.1 -best_hit_overhang 0.25 -outfmt 6 -num_alignments 1 | awk '{print "\""$2"\""}' | xargs samtools faidx ~/Bioinformatics/Physcomitrella/CDS_fasta_index/Ppatens_152_cds_primaryTranscriptOnly.fa > $prefix.missingPhysco.fasta

done 