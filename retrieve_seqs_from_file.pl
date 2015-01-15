#!/usr/bin/perl -w
use Bio::Seq;
use Bio::SeqIO;
use strict;

if (!$ARGV[2]){
    print "USAGE: retrieve_seqs_from_file.pl <ID_LIST> <INPUT_FASTA> <OUTPUT_FASTA>\n";
    exit(1);
}
my $id_list = "$ARGV[0]";
my $input_fasta = $ARGV[1];
my $output_fasta = $ARGV[2];
my %list;

open (IN, "$id_list") or die "Couldn't open $id_list file $!";
while (<IN>){
    chomp;
    $list{$_} = $_;
}
close IN;

my $inputIO_obj = Bio::SeqIO->new(-file => "$input_fasta", -format => "fasta" );
my $outputIO_obj = Bio::SeqIO->new(-file => ">$output_fasta", -format => 'fasta' );
while (my $input_obj = $inputIO_obj->next_seq){
    if (!$list{$input_obj->display_id}){next;}
    # print the sequence   
    $outputIO_obj->write_seq($input_obj);
}
