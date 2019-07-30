# Extract_specific_sequence_from_fasta

# DESCRIPTION

	Extract specific sequences from a fasta file containing multiple sequences.
	Names of the sequences to extract are provided in a csv file.
	Csv field and separator can be modified (first comma-separated field used by default).

# USAGE

	perl extract_specific_sequence_from_fasta.pl  -c csv.csv -i in.fasta [-f 2] [-o output_file] [-s ";"]

# OPTIONS

	-c or -csv:	Csv file	(REQUIRED)
	-i or -fasta:	Fasta file	(REQUIRED)
	-o or -out:	Output File	(DEFAULT: [input_name].subset.fasta)
	-f or -field:	Field containing sequences names (DEFAULT: 0)
	-s or -separator:	Csv separator (DEFAULT: ",")

	-h or -help:	This Documentation

# AUTHOR

	Damien Richard, 2019
