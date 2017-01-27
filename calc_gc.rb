#!/usr/bin/env ruby

require 'bio'

ff = Bio::FlatFile.auto(ARGF)
cat = ""
ff.each_entry do |entry|
  cat = cat + entry.seq 
end
total_seq = Bio::Sequence::NA.new(cat)
gc = total_seq.gc_content.to_f
puts ARGF.filename + "\t" + gc.to_s
