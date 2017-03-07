#!/usr/bin/env ruby

require 'bio'
require 'trollop'

#This program pulls out all the sequences associated with an OTU designation
#Be aware that this will not extract duplicate sequences, unless you did not
#dereplicate before clustering

opts = Trollop::options do
  opt :f,   "Sequence file (fasta or fastq)", :type => :string, :required => true
  opt :u,   "UP file from uclust",            :type => :string, :required => true
  opt :otu, "OTU to extract",                 :type => :string, :required => true
end

#initialize variables
seqs     = Bio::FlatFile.auto(opts.f)
up_file  = File.open(opts.u)
otu      = opts.otu
otu_seqs = []

up_file.each do |l|
  if /#{otu}\s+/.match(l)

    #Deal with 'size=' not being in the original header
    h = ''
    if /(.+)size.+/.match(l.split[0])
      h = /(.+)size.+/.match(l.split[0])[1]
    else
      h = l.split[0]
    end

    #Then add this header to our list we'll be extracting
    otu_seqs.push(h)
  end
    
end

#Loop through all the sequences, and pull the matching headers from the sequence file
seqs.each do |rec|
  t = 0 #for easy checking if initialized
  
  otu_seqs.each do |r|
    t = r if rec.definition.match(r.to_s)
  end

  if t != 0 
    File.open("#{otu}.fa", 'a').puts rec
  end
  
end


