#!/usr/bin/perl -w
use strict;
use 5.012;
use utf8;
use feature 'unicode_strings';
use open ':std', ':locale';

use Data::Dumper;

opendir(my $dh, "DATA") || die "Can't open DATA: $!";
my @tsvs = grep { /\.tsv$/ && -f "DATA/$_" } readdir($dh);
closedir($dh);

sub reducedir($) {
        my $dir = uc shift || die "need an argument";
        print $dir;
        $dir =~  m/^(?:(?:AV.|PTE.|PRES.) )?([\w\s\.]+)(?: N[º°]+) (\d+)/ and return "$1 $2";
        $dir =~m/([\w\s,]+)(?: AV.)? (\d+)(?:[$ ,])/ and return "$1 $2";
        print "Couldn't parse: $dir\n";
        return $dir;
}

sub tsv2hash($) {
        my $tsv = shift || die "needs an argument";
        print "processing $tsv\n";
        my %res;

        open(my $fh, "DATA/".$tsv) || die "Can't open $tsv: $!";
        my @keys = split /\t/, <$fh>;
        while (<$fh>) {
                my %item;
                my @values = split /\t/;
                @item{@keys} = @values;
                my $dir = reducedir ($item{'DIRECCION'});
                print "-> dir: $dir\n";
                $res{$dir} = \@values;
        }

        return %res;
}

my %base = tsv2hash(pop @tsvs);

#my %results = map { $_ => tsv2hash($_) } @tsvs;
