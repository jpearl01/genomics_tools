#!/usr/bin/perl

use strict;
use warnings;

print "This program's intention is to print how many core genes are lost as new genomes are added to the clustering project\n";
print "Initial_size\tOne_added\tGenome_added\tcore_added\tcore_removed\ttotal_final_core\n";

`mkdir reports` unless (-d "reports");

for my $i (2..55){
    open (F, "$i/report_output") or die "can't open report_output\n";
    my @a=[]; 
    while(<F>){
	push @a, $_;
	last if /report stop/;
    }
    open (O,">reports/$i.report") or die "couldn't write outfile\n";
    print O @a
}
for my $i (2..54) {
    my $j = $i+1;
    my @a = `diff -y reports/$i.report reports/$j.report|grep '<'|grep -v '>'`;    
    my $loss = scalar(@a);
    my @b = `diff -y reports/$i.report reports/$j.report|grep '>'|grep -v '<'`;
    my $add = scalar(@b);
    my $total_core = `grep core reports/$j.report|cut -d : -f 2`;
    chomp $total_core;
    my $genome_added = `tail -1 $j/strain_list`;
    chomp $genome_added;
#    print "-----------------------\nGoing from $i to $j genomes\tAdded: $add\tlost:\t$loss\n"; 
    print "$i\t$j\t$genome_added\t$add\t$loss\t$total_core\n";
#    print @b;
}
