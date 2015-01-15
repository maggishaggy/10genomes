#! /usr/bin/env python
# BUILT BY JOSH DER, MADE TO WORK BY WILLIAM EHLHARDT
# filterfasta.py
# Filter a fasta file to include or exclude a list of sequences.
# Prints to STDOUT, so redirect to file.
# Usage: filter_fasta.py <sequence or quality fasta file> <list of sequence identifiers> "yes" || "no"
#

# import modules
from sys import argv  # gives us a list of command line arguments
from Bio import SeqIO  # biopython tools for reading/parsing sequence files

# get file names
seqFileName = argv[1]
listFileName = argv[2]
# keep or exclude the list; default to keep
if (len(argv) > 3):
    keep = argv[3]
else:
    keep = "yes"

# get and store the list of sequence id's
idList = set()
with open(listFileName, "r") as listFileHandle:
    for line in listFileHandle:
        line = line.rstrip()  #remove the line endings
        idList.add(line)

def is_a_target(title):
    return any(id in title for id in idList)

# index the fasta file (acts like a dictionary but without the memory contraints)
# the sequence id is the dictionary key
seqRecords = SeqIO.index(seqFileName, "fasta")

for title in seqRecords.keys():
    if keep == "yes":
        should_output = is_a_target(title)
    else:
        should_output = not is_a_target(title)
    if should_output:
        # Isn't there some way to serialize this that doesn't involve you
        # writing the format out yourself?
        print ">" + title
        print seqRecords[title].seq
