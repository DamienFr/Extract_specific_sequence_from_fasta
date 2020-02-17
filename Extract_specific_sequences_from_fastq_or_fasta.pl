#!/usr/bin/perl
use Bio::SeqIO;
use Getopt::Long;

# use strict;
# use warnings;
# use Text::CSV;

=head1 DESCRIPTION

	Extract specific sequences from a fasta or fastq file containing multiple sequences.
	Names of the sequences to extract are provided in a csv file.
	Csv field and separator can be modified (first comma-separated field used by default).

=head1 USAGE

	perl Extract_specific_sequences_from_fastq_or_fasta.pl  -c csv.csv -i in.fasta|.fa|.fastq|.fq [-f 2] [-o output_file] [-s ";"]

=head1 OPTIONS

	-c or -csv:	Csv file	(REQUIRED)
	-i or -input:	fasta or fastq file	(REQUIRED)
	-o or -out:	Output File	(DEFAULT: [input_name].subset)
	-f or -field:	Field containing sequences names. In perl first field is 0. (DEFAULT: 0)
	-s or -separator:	Csv separator (DEFAULT: ",")

	-h or -help:	This Documentation

=head1 AUTHOR

	Damien Richard, 2019

=cut

my $csv_file; my $fastq_file; my $separator = ","; my $field = 0; my $out; my $hl; my $nb_out; my $nb_in;

GetOptions(
	"c|csv=s" => \$csv_file,
	"i|input=s" => \$fastq_file,
	"s|separator=s" => \$separator,
	"o|out=s" => \$out,
	"f|field:i" => \$field,
	"h|help" => \$hl,
);

die `pod2text $0` unless $csv_file && $fastq_file;
die `pod2text $0` if $hl;

my $input_type;
if($fastq_file =~ /.*.fa/ || $fastq_file =~ /.*.fasta/){ $input_type = "fasta" }elsif($fastq_file =~ /.*.fq/ || $fastq_file =~ /.*.fastq/){ $input_type = "fastq" }else{ print STDERR "Input type not recognized. " . $fastq_file . " has to display .fa .fasta .fq or .fastq extension\n"; die `pod2text $0` }

if(!$out){$out = $fastq_file . ".subset";}
# End of user interface code, beginning of program: 


my %h;

# version SANS Text::CSV
sub openfile{
 $file = $_[0]; 
 $fields_nb = $_[1];
 $field_key = $_[2];
 $field_value = $_[3];
 $delimiter = qr/$_[4]/;
 if($#_ != 4){die "openfile subroutine called with $#_ arguments instead of 4 required\n";}
 open (GB, "<", $file) or die "could not open $file for read in openfile subroutine\n";
 while ($line = <GB>) {
  $line =~ s/\r?\n//g;
  @fields = split $delimiter,$line;

  $h{$fields[$field_key]} = $fields[$field_value];

 }
 close GB ; 

 return %h;
} 

%h = openfile($csv_file,0,$field,$field,$separator); # file,NB,key,value,"\\|"

# version AVEC Text::CSV
# my $csv_object = Text::CSV->new( { sep_char => $separator } );

# open( my $data, '<', $csv_file ) or die "Could not open '$csv_file' $!\n";
# print "Processing csv file ...\n";
# while ( my $line = <$data> ) {
 #    chomp $line;
  #   if ( $csv_object->parse($line) ) {
   #      my @fields = $csv_object->fields();
    #     $h{ $fields[$field] } = "ok";
   #  }
   #  else { warn "Csv line could not be parsed: $line\n"; }
# }

my $fastq_in ;
my $fastq_out;

if($input_type eq "fastq"){

 $fastq_in  = Bio::SeqIO->new( -file => $fastq_file,       -format => 'fastq' );
 $fastq_out = Bio::SeqIO->new( -file => ">" . $out, -format => 'fastq' );
print "Processing fastq file ...\n";

}else{

$fastq_in  = Bio::SeqIO->new( -file => $fastq_file,       -format => 'fasta' );
 $fastq_out = Bio::SeqIO->new( -file => ">" . $out, -format => 'fasta' );
print "Processing fasta file ...\n";

}


while ( my $seq = $fastq_in->next_seq() ) {
	$nb_in++;
    if ( exists( $h{ $seq->id } ) ) {
    $nb_out++;
        $fastq_out->write_seq($seq);
    }
}

print "Process terminated, output file is $out\nIt contains $nb_out out of $nb_in sequences of original fastq/fasta file\n";
print "This program does not check whether all the titles of the csv file are present in the fastq/fasta file. It will only extract found identifiers without warning you that some were not found"













