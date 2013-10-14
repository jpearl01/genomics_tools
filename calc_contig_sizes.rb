#!/usr/bin/env ruby

require 'bio'
f=ARGF.filename
puts f
ff = Bio::FlatFile.auto(f)
cat = ""
ff.each_entry do |entry|
  puts File.basename(f, ".*") + "\t" + entry.definition + "\t" + entry.seq.size.to_s
end
puts "End of Record"
