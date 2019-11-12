#!/usr/bin/env ruby

# Command to use to run the script: ./dataCleaned.rb > out.json
# The script takes the json files & looks for the reference number & notes
# section. It then puts the data into a json file & ignores the ones with null
# for the notes section.

require 'json'

path = './txt_cleaned'
files = Dir["#{path}/*.json"]

results = []

files.each do |filename|
  text = File.read(filename)
  my_hash = JSON.parse(text)
  reference_number = my_hash['reference_number']
  notes = my_hash['clauses'].last['notes']
  unless notes.nil?
    results << { 'reference_number': reference_number, 'notes': notes }
  end
end

puts JSON.pretty_generate(results)
