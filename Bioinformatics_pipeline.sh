## Start with a folder full of FASTA files of Arabidopsis families. The file names should end "genes.fa"
#
#
### Script to strip At numbers out of FASTA file, by William Ehlhardt. perl from Loren Honaas
###########sh ~/Scripts/get_At_numbers_from_fastas.sh
##! /bin/bash
#
## This bad boy is a list of yer input files. But you knew that!
#files=*genes.fa
#
#for file in files
#do
#  # BLAHgenes.fa ---> BLAH
#  prefix=`basename $file genes.fa`
#  # perl -e YOUR_CRAP < BLAHgenes.fa > /generic_directory/BLAH.txt
#  perl -e 'while(<>){if(/^>(\w+)/){print "$1\n";}}' < $file > /generic_directory/$prefix.txt
#  # perl blob uses regular expressions to grab the At number out of lines that begin ">"
#done
#
###
#
## you now have a folder full of files full of At numbers
#
### Script to grab orthogroup members from 10_genomes database from William
sh ~/Scripts/getorthogroupmembers.sh
#
##! /bin/bash
#
## This bad boy is a list of yer input files. But you knew that!
#files=*.txt
#
#for file in $files
#do
#  # BLAHgenes.fa ---> BLAH
#  prefix=`basename $file .txt`
#  # calls Loren's perl script using each file as the search term for the 10_genomes database. The script has been modified to ignore species requirements, and the output is named after the input file
#  perl ~/Dropbox/Bioinformaticscollaboration/scriptsfromLoren20130304/ortho_fasta_find.pl $file ~/Dropbox/Bioinformaticscollaboration/scriptsfromLoren20130304/10_genomes.ortho.txt Arath $prefix.family.txt
#done
#
###
#
###Here is Loren's perl script called by the above
#
##!/usr/bin/perl
#use warnings;
#use strict;
#if (!$ARGV[3]) {
#	print "USAGE ortho_fasta_find.pl <AT_ID_list> <10_genomes.ortho.txt> <Species 5 letter abbreviation> <output file.name> \n\n";
#	exit(1);
#}
#my $IDs = $ARGV[0];
#my $ortho_IDs = $ARGV[1];
#my $species = $ARGV[2];
#my $output_ID_list = $ARGV[3];
#my %ID_list;
#open(IN, "<$IDs") || die "Cannot open ID list!\n\n";
#while(my $id = <IN>){
#    chomp $id;
#    $ID_list{$id} = $id; #print "$id\n"
#    }
#my %ortho_list;
#open (IN, "<$ortho_IDs") || die "Cannot open ortho summary file!\n\n";
#while(my $ortho_file = <IN>){
#    if($ortho_file =~ /(\d+)(.+)\|(\w+)$/){
#        my $orthogroup = $1; #print "$3\n";
#        if(exists $ID_list{$3}){ #print "$3\n";
#            $ortho_list{$1} = $1; 
#        }
#    }
#}
#close IN;
#open (OUT, ">$output_ID_list");
#open (IN, "<$ortho_IDs") || die "Cannot open ortho summary file!\n\n";
#while(my $ortho_file = <IN>){
#    chomp $ortho_file;
#    $ortho_file =~ /(\d+)(\s+)(\S+)/;
#    my $gene = $3;
#    if (exists $ortho_list{$1}){ #print "$ortho_file\n"{
#        #if ($gene =~ /$species/){
#             print OUT "$gene\n";
#        #}
#    }
#}
#close IN;
#exit(0);
#
###
#
## You now have a bunch of files that end ".family.txt" containing all the orthogroup members with names in the 10_genomes format
## Some of the Arabidopsis genes will not be sorted into orthogroups. These can be discovered by running the following script
#
### Script to collect dropped Arabidopsis genes, written by Thomas McCarthy
sh ~/Scripts/collectmissingAtnumbers.sh
#
##! /bin/bash
#
## This bad boy is a list of yer input files. But you knew that!
#files=*.family.txt
#
#for file in $files
#do
#  # BLAHgenes.family.txt ---> BLAH
#  prefix=`basename $file .family.txt`
#  # Identify all the Arabidopsis At numbers sorted into orthogroups
#  cat $prefix.family.txt | grep Arath | cut -c 12- > foundAts.txt
#  # Search original list of At numbers for members NOT in foundAts.txt
#  cat $prefix.txt | grep -v -f foundAts.txt > $prefix.missingAts.txt
#  # clean up the foundAts.txt file
#  rm foundAts.txt
#done 
#
## The gene sequences for all the genes correctly sorted into orthogroups are obtained with the following script
#
### Script to get fasta sequences for each family by William Ehlhardt with the blastdbcmd from Loren Honaas
sh ~/Scripts/getfastasequences.sh
#
##! /bin/bash
#
## This bad boy is a list of yer input files. But you knew that!
#files=*.family.txt
#
#for file in $files
#do
#  # BLAHgenes.fa ---> BLAH
#  prefix=`basename $file .family.txt`
#  ~/bin/blastdbcmd -db ~/Dropbox/Bioinformaticscollaboration/10_genomesdatabase/10_genomes.cds -entry_batch $file -out $prefix.orthogroupmembers.fasta -dbtype nucl
#  # This calls the blast database command to search the 10_genomes database for all the members of each file and puts them out in a fasta file named after the input.
#  # Note that it is named .fasta, not.fa
#done 
#
###
#
### In order to identify the sequences of the dropped At numbers, they need to be fed into the following script
# ~/Scripts/filter_fasta_willy.py
##! /usr/bin/env python
## BUILT BY JOSH DER, MADE TO WORK BY WILLIAM EHLHARDT
## filterfasta.py
## Filter a fasta file to include or exclude a list of sequences.
## Prints to STDOUT, so redirect to file.
## Usage: filter_fasta.py <sequence or quality fasta file> <list of sequence identifiers> "yes" || "no"
##
#
## import modules
#from sys import argv  # gives us a list of command line arguments
#from Bio import SeqIO  # biopython tools for reading/parsing sequence files
#
## get file names
#seqFileName = argv[1]
#listFileName = argv[2]
## keep or exclude the list; default to keep
#if (len(argv) > 3):
#    keep = argv[3]
#else:
#    keep = "yes"
#
## get and store the list of sequence id's
#idList = set()
#with open(listFileName, "r") as listFileHandle:
#    for line in listFileHandle:
#        line = line.rstrip()  #remove the line endings
#        idList.add(line)
#
#def is_a_target(title):
#    return any(id in title for id in idList)
#
## index the fasta file (acts like a dictionary but without the memory contraints)
## the sequence id is the dictionary key
#seqRecords = SeqIO.index(seqFileName, "fasta")
#
#for title in seqRecords.keys():
#    if keep == "yes":
#        should_output = is_a_target(title)
#    else:
#        should_output = not is_a_target(title)
#    if should_output:
#        # Isn't there some way to serialize this that doesn't involve you
#        # writing the format out yourself?
#        print ">" + title
#        print seqRecords[title].seq
#
###
#
### To automate this for all the missing At numbers, here is a script
sh ~/Scripts/identifymissingAtnumbersequences.sh
##! /bin/bash
#
## This bad boy is a list of yer input files. But you knew that!
#files=*.missingAts.txt
#
#for file in $files
#do
#  # BLAH.missingAts.txt ---> BLAH
#  prefix=`basename $file .missingAts.txt`
#  # Search Arabidopsis CDS file for sequences in file
#  python ~/Scripts/filter_fasta_willy.py ~/Bioinformatics/Arabidopsis/Athaliana_167_cds_primaryTranscriptOnly.fa $prefix.missingAts.txt > $prefix.missingAts.fasta
#done 
#
###
#
## The missing Arabidopsis genes need to be checked for close homologs in Physcomitrella using BLAST. False positives can be dropped during the alignment process
##########sh ~/Scripts/crosscheckPhyscowithmissingAts.sh
#
##! /bin/bash
#
## This bad boy is a list of yer input files. But you knew that!
#files=*.missingAts.fasta
#
#for file in $files
#do
#  # BLAH.missingAts.fasta ---> BLAH
#  prefix=`basename $file .missingAts.fasta`
#  # tBLASTx Physcomitrella genome with the missing Arabidopsis genes and take the best match for each gene if it exceeds the quality threshold
#  # output is in tabular format and fed to awk script that takes column 2 (the physco id) and prepares it for the samtools index of the Physco CDS fasta
#  tblastx -query $prefix.missingAts.fasta -db ~/Bioinformatics/Physcomitrella/Blast_database/Ppatens_152_cds_primaryTranscriptOnly -evalue 1E-10 -matrix BLOSUM62 -best_hit_score_edge 0.1 -best_hit_overhang 0.25 -outfmt 6 -num_alignments 1 | awk '{print "\""$2"\""}' | xargs samtools faidx ~/Bioinformatics/Physcomitrella/CDS_fasta_index/Ppatens_152_cds_primaryTranscriptOnly.fa > $prefix.missingPhysco.fasta
#
#done 
#
###
#
## These three fasta files, .orthogroupmembers.fasta, .missingAts.fasta, and .missingPhysco.fasta need to be joined into a final fasta for alignment
sh ~/Scripts/concatenate_fastas.sh
##! /bin/bash
#
## This bad boy is a list of yer input files. But you knew that!
#files=*.orthogroupmembers.fasta
#
#for file in $files
#do
#  # BLAH.orthogroupmembers.fasta ---> BLAH
#  prefix=`basename $file .orthogroupmembers.fasta`
#  # concatenate the three fasta files generated into one suitable for alignment. 
#  cat $prefix.orthogroupmembers.fasta $prefix.missingAts.fasta $prefix.missingPhysco.fasta > $prefix.assembly.fasta
#done 
#
#
#
## Once you have the fasta files, you can align them in Geneious, or theoretically using command line muscle or other algorithms
## Assuming you have an alignment that is properly curated, save it in the relaxed Phylip format.
## It can be submitted to the Lion-XG cluster for the generation of trees with RAxML using .pbs files
#
### script to generate .pbs files to submit jobs on the lion-x clusters, written mostly by Bill Murphy
#~/Scripts/generate_pbs_from_alignment.py
#
## Call this python script with a directory as the argument. It will generate .pbs files for submission to lion-xg cluster
#
#from subprocess import Popen, PIPE
#from shlex import split
#from re import sub
#import sys
#
#def create_files(directory):
#    #the beginning of the .pbs file
#    front = """
#    #PBS -l nodes=8
#    # Lion-xg allows requesting processor cores as nodes instead of making them separate. This asks for 8 processors on any of the nodes in the cluster since this version of RAxML runs different threads on different cores
#    #PBS -l walltime=02:00:00
#    # 2 hours of wall time seems to be enough for all the alignments submitted so far
#    #PBS -l pmem=1gb
#    # As far as I can tell one GB of memory is plenty
#    #PBS -j oe
#    # set nodes to CPU number, allowing for use of cores on any nodes
#    cd $PBS_O_WORKDIR
#    date
#    
#    module load openmpi/gnu
#    mpirun ~/work/bin/raxmlHPC-MPI -s """
#    
#    #the rest of the pbs file, i.e. the stuff after the parameter we are going to alter
#    back = """ -m PROTCATLGF -p 12345 -x 12345 -f a -N 100 
#    # calling raxml mpi version (multiple nodes) -x random seed -f a is a rapid bootstrap analysis with an optimal tree search in the same run
#    # -N number of bs replicates -m model of sequence evolution
#    
#    date
#    """
#    
#    #create a subprocess to get the files in the current directory
#    proc = Popen(split("ls " + directory), stdout=PIPE, stderr=PIPE)
#    
#    #run the subprocess
#    stdout, stderr = proc.communicate()
#    
#    #parse the output of ls to get the list of files
#    files = stdout.split("\n")[:-1]
#    
#    #loop over the files
#    for filename in files:
#        #create a new file
#        writefile = open(filename[:-4] +".pbs", "w")
#        
#        #remove "alignment EDIT" and ".phy"
#        #these can be altered to clean up output files
#        honk = sub("_translation_alignment_EDIT.phy", "", filename)
#        mid = sub("Arabidopsis", "", honk)
#        
#        #write the whole thing to a file,
#        #concatenating the beginning of the pbs file, the parameter, and the stuff after
#        writefile.write(front + filename + " -n " + mid + back)
#        
#        #close the file
#        writefile.close()
#    
#if __name__ == "__main__":
#    create_files(sys.argv[1])    
#
###
#
#
#
##Login to Lion-XG. The G is important, as it is the cluster on which this version of RAxML was compiled
#ssh txm5136@lionxg.rcc.psu.edu
#cd work
#mkdir workspaceDATE
#cd workspaceDATE
#
## You will need a way to move files to and from your local computer. I found secure FTP to be the simplest
## In another terminal, navigate to the directory containing your alignments
#sftp txm5136@lionxg.rcc.psu.edu
#cd work
#cd workspaceDATE
#put *.phy
#put *.pbs
## This will move all your alignment and submission files to the directory on the cluster.
## Now return to the first terminal where you are using ssh
#qsub *.pbs
## This should submit all the files as separate jobs. As they finish, the directory will fill with RAxML files. If there is an error some of the files will not appear. Information on the running and any errors will be available in a file that has the same name as the .pbs submission file with the cluster run number appended.
#
