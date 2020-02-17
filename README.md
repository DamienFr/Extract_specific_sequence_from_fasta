# Extract_specific_sequences_from_fasta_or_fastq

# DESCRIPTION

	Extract specific sequences from a fasta or fastq file containing multiple sequences.
	Names of the sequences to extract are provided in a csv file.
	Csv field and separator can be modified (first comma-separated field used by default)..

# USAGE

	perl Extract_specific_sequences_from_fastq_or_fasta.pl  -c csv.csv -i in.fasta|.fa|.fastq|.fq [-f 2] [-o output_file] [-s ";"]

# OPTIONS

	-c or -csv:	Csv file	(REQUIRED)
	-i or -input:	fasta or fastq file	(REQUIRED)
	-o or -out:	Output File	(DEFAULT: [input_name].subset)
	-f or -field:	Field containing sequences names. In perl first field is 0. (DEFAULT: 0)
	-s or -separator:	Csv separator (DEFAULT: ",")

	-h or -help:	This Documentation

# AUTHOR

	Damien Richard, 2019
