#!/usr/bin/env ruby

require 'bio'

#This file accepts a fastq formatted file and returns the average, min, and max
#of the average quality of each read.


#This better be a fastq file
qual = Bio::FlatFile.auto(ARGV[0])
abort("Must be a fastq file") unless qual.dbclass=="Bio::Fastq"
qual.each do |q|

  currQual = q.qualities.reduce(:+).to_f / q.qualities.size
  puts q.definition + " " +currQual.to_s

end
