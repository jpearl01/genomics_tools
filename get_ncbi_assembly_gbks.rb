#/usr/bin/env ruby

require 'open-uri'

#Usage: ruby get_ncbi_assembly_gbks.rb "Moraxella catarrhalis"
#Creates a 'genomes' folder and puts all fasta assemblies there, named by 'strain'
#Also creates a file with record information for each strain 'strain_records.tsv'

species = ARGV[0].to_s
puts "Searching for species: "+ species

Dir.mkdir("genomes_gbk") unless File.exists?("genomes_gbk")

out = File.open('strain_records_gbk.tsv', 'w')

open('ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/assembly_summary.txt').each do |line|
  if /#{species}/.match(line)
    out.puts(line)
    a = line.split("\t")
    ftp = a[-3]
    strain = a[8].split("=")[-1]
#    puts ftp
    if /^ftp/.match(ftp)
      name = ftp.split("/")[-1]
      name = [name, "genomic.gbff.gz"].join("_")
      strain = strain.split(" ").join("_") if /\s/.match(strain)
      IO.copy_stream(open(ftp+"/"+name), "genomes_gbk/#{strain}.gbff.gz")
    end
  end
end
