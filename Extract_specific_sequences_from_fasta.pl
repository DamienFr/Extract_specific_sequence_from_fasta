#!/usr/bin/perl
use strict;
use warnings;
use Bio::SeqIO;
use Text::CSV;
use Getopt::Long;

=head1 DESCRIPTION

	Extract specific sequences from a fasta file containing multiple sequences.
	Names of the sequences to extract are provided in a csv file.
	Csv field and separator can be modified (first comma-separated field used by default).

=head1 USAGE

	perl Extract_specific_sequences_from_fasta.pl  -c csv.csv -i in.fasta [-f 2] [-o output_file] [-s ";"]

=head1 OPTIONS

	-c or -csv:	Csv file	(REQUIRED)
	-i or -fasta:	Fasta file	(REQUIRED)
	-o or -out:	Output File	(DEFAULT: [input_name].subset.fasta)
	-f or -field:	Field containing sequences names (DEFAULT: 0)
	-s or -separator:	Csv separator (DEFAULT: ",")

	-h or -help:	This Documentation

=head1 AUTHOR

	Damien Richard, 2019

=cut

my $csv_file; my $fasta_file; my $separator = ","; my $field = 0; my $out; my $hl; my $nb_out; my $nb_in;

GetOptions(
	"c|csv=s" => \$csv_file,
	"i|fasta=s" => \$fasta_file,
	"s|separator=s" => \$separator,
	"o|out=s" => \$out,
	"f|field:i" => \$field,
	"h|help" => \$hl,
);


die `pod2text $0` unless $csv_file && $fasta_file;
die `pod2text $0` if $hl;

if(!$out){$out = $fasta_file; $out =~ s/.fasta$|.fa$/.subset.fasta/;}
# End of user interface code, beginning of program: 

my $csv_object = Text::CSV->new( { sep_char => $separator } );
my %h;

open( my $data, '<', $csv_file ) or die "Could not open '$csv_file' $!\n";
print "Processing csv file ...\n";
while ( my $line = <$data> ) {
    chomp $line;
    if ( $csv_object->parse($line) ) {
        my @fields = $csv_object->fields();
        $h{ $fields[$field] } = "ok";
    }
    else { warn "Csv line could not be parsed: $line\n"; }
}

my $fasta_in  = Bio::SeqIO->new( -file => $fasta_file,       -format => 'Fasta' );
my $fasta_out = Bio::SeqIO->new( -file => ">" . $out, -format => 'Fasta' );

print "Processing fasta file ...\n";
while ( my $seq = $fasta_in->next_seq() ) {
	$nb_in++;
    if ( exists( $h{ $seq->id } ) ) {
    $nb_out++;
        $fasta_out->write_seq($seq);
    }
}

print "Process terminated, output file is $out\nIt contains '$nb_out'/'$nb_in' sequences of original fasta file\n";














