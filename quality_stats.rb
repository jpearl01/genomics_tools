#!/usr/bin/env ruby

require 'bio'

#This file accepts a fastq formatted file and returns the average, min, and max
#of the average quality of each read.


totalReads  = 0
totalQual   = 0
averageQual = 0
minQual     = 1000
maxQual     = 0

minRead = 20000
maxRead = 0

#This better be a fastq file
qual = Bio::FlatFile.auto(ARGV[0])
qual.each do |q|
  currQual = q.qualities.reduce(:+).to_f / q.qualities.size

#  fq = q.to_s.split.map(&:to_i)
#  currQual = fq.reduce(:+).to_f / fq.size
  totalQual += currQual
  totalReads += 1

  minQual = currQual if currQual < minQual
  maxQual = currQual if currQual > maxQual

  minRead = fq.size if fq.size < minRead
  maxRead = fq.size if fq.size > maxRead

end

averageQual = totalQual/totalReads

puts "Total Average quality:  #{averageQual}"
puts "Total reads:            #{totalReads}"
puts "Minimum Read Quality:   #{minQual}"
puts "Maximum Read Quality:   #{maxQual}"
puts "Minimum Read Length:    #{minRead}"
puts "Maximum Read Length:    #{maxRead}"


#I don't know what I was doing here
#  fr.qualities.inject{|sum, e1| sum+e1}.to_f / fr.qualities.size
