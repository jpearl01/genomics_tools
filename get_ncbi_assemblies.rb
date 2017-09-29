#/usr/bin/env ruby

require 'open-uri'

species = ARGV[0].to_s
puts "Searching for species: "+ species

Dir.mkdir("genomes") unless File.exists?("genomes")

open('ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/assembly_summary.txt').each do |line|
  if /#{species}/.match(line)
    a = line.split("\t")
    ftp = a[-3]
    strain = a[8].split("=")[-1]
#    puts ftp
    if /^ftp/.match(ftp)
      name = ftp.split("/")[-1]
      name = [name, "genomic.fna.gz"].join("_")
      strain = strain.split(" ").join("_") if /\s/.match(strain)
      IO.copy_stream(open(ftp+"/"+name), "genomes/#{strain}.fna.gz")
    end
  end
end
