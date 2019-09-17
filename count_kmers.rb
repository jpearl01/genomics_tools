#!/usr/bin/env ruby

require 'bio'
require 'optimist'

opts = Optimist::options do
  banner <<-EOS
  This script counts the number of kmers that exist in a fasta file. 

  Usage(basic):
         ruby count_kmers.rb -k 4 -f reference_seq.fasta 
  Options:
  EOS

  opt :kmer_len, "Length of the kmer being counted", type: :int, short: "-k"
  opt :fasta_file, "File of sequence to iterate over", type: :string, short: "-f"
end 


window_size = opts[:kmer_len]
step_size   = 1
kmer_dict = {}
dict_size = 4 ** window_size
found_expected_size = false
num_records_to_full_dict = 0
num_bases_searched = 0

puts "Expected dictionary size of kmers is #{dict_size} for kmers of size #{window_size}"

Bio::FlatFile.auto(opts[:fasta_file]) do |ff|
	ff.each do |entry|

		num_records_to_full_dict += 1
		num_bases_searched += entry.to_seq.length
#		puts "Searching #{entry.first_name}..."
		
		entry.to_seq.window_search(window_size, step_size) do |subseq|
			#We don't want to count ambiguous bases as real kmers
			next if /[^ACTG]/.match(subseq)
			#
			if kmer_dict.has_key?(subseq)
  			kmer_dict[subseq] += 1
  		else
  			kmer_dict[subseq] = 1
  		end
  		break if kmer_dict.size == dict_size
		end

		abort "Found too many kmers! Kmer that broke this: #{subseq}" if kmer_dict.size > dict_size

		if kmer_dict.size == dict_size 
			puts "At time #{Time.now} we found all kmers of length #{window_size}."
			puts "Searched #{num_records_to_full_dict} records, containing #{num_bases_searched} bases" 
			abort "Finished search."
		end

	end
end

puts "Size of the found kmer dictionary is #{kmer_dict.size}"


