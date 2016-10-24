#!/bin/perl

use warnings;
use strict;

use File::Basename;
use Lingua::StopWords qw( getStopWords );

local $\ = "\n";

my $num_args = $#ARGV + 1;
if($num_args != 1) {
    my $file = basename($0);
    print "\nUsage: $file datafile-path";
    exit;
}


# open input file
my $input_file = $ARGV[0];
print "readig $input_file";

open(my $fh, '<:encoding(UTF-8)', $input_file)
  or die "Could not open file '$input_file' $!";


#extract tweet and remove stopwords
my $delim = "\\*,,,\\*";
my $stopwords = getStopWords('en');
while(my $line = <$fh>) {
    chomp $line;
    my @attributes = split /$delim/, lc($line);
    my @words = split ' ', $attributes[2];
    my @filtered_words = grep { !$stopwords->{$_} } @words;
    for my $wrd (@filtered_words) {
        if($wrd !~ /(\\u[a-z0-9]{4})+|http[s]{0,1}:.*|^[-!$%^&*()_+|~=`{}\[\]:";'<>?,.\/]+$/ && length($wrd) > 2) {
            print $wrd;
        }
    }
}
