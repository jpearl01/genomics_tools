#!/usr/bin/env ruby

require 'bio'

#fq = Bio::FlatFile.auto('filtered_subreads.fastq')
#fr = fq.first
#fr.qualities.inject{|sum, e1| sum+e1}.to_f / fr.qualities.size
#fr.qualities.reduce(:+).to_f / fr.qualities.size


totalReads  = 0
totalQual   = 0
averageQual = 0
minQual     = 1000
maxQual     = 0

minRead = 20000
maxRead = 0

qual = Bio::FlatFile.auto('/home/pacbio/Xf10_11_25_29_082212_59/Xf10.qual')
qual.each do |q|
  fq = q.to_s.split.map(&:to_i)
  currQual = fq.reduce(:+).to_f / fq.size
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
