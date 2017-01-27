#!/usr/bin/env ruby

require 'bio'

def write_na_genes (f)
  abort("Couldn't open the file #{f}") unless File.exists?(f)
  f_basename = File.basename(f, ".gbk")
  outfile = File.open("na_genes/" + f_basename + ".fna", 'w')
  bio_gbk = Bio::GenBank.open(f)
  count = 0
  print "#{f_basename} writing NA genes... "
  bio_gbk.each do |e|
    #Need to drop the first record, as it is the entire contig
    e.features.drop(1).each do |gene|
      #        next unless gene.feature == 'CDS'
      count += 1
      na_seq = Bio::Sequence::NA.new(e.naseq.splicing(gene.position))
      outfile.write(na_seq.to_fasta(f_basename + "_" + count.to_s))
    end
    
  end
  puts "#{f_basename} wrote #{count} na genes"
  
end
Dir.mkdir('na_genes') unless File.exists?('na_genes')
write_na_genes(ARGV[0])
