#!/usr/bin/env ruby

require 'bio'
require 'trollop'

opts = Trollop::options do
  opt :f, "Fasta file", :type => :string
  opt :l, "List of headers", :type => :string
end

ncbi = Bio::FlatFile.auto(opts.f)

headers = File.open(opts.l)

records = {}

headers.each do |h|
  records[h.strip] = ''
end

ncbi.each do |rec|
  t = 0
  records.each_key do |r|
    t = r if rec.definition.match(r.to_s)
  end
  if t != 0 
    File.open("#{t}.fa", 'a').puts rec
  end
end
