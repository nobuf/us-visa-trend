require 'roo'
require 'csv'

def load_countries
  countries = {}
  CSV.foreach(ARGV[1], {headers: true}) do |row|
    countries[row['name']] = {
      latitude: row['latitude'],
      longitude: row['longitude'],
    }
  end
  countries
end

countries = load_countries

s = Roo::Excel.new(ARGV[0])
body = []
headers = []
s.each_with_pagename do |name, sheet|
  begin
    year = Date.strptime(name, 'FY%y').year
  rescue ArgumentError
    next # skip "Sheet2"
  end
  header = sheet.row(sheet.first_row)
  header.map! {|x| x.to_s}
  header[0] = :name
  headers.concat(header)
  2.upto(sheet.last_row) do |idx|
    row = sheet.row(idx)
    next if row[1].nil?
    next if row[0].index('Totals for ') == 0
    row = row.each_with_index.map do |x, i|
      i == 0 ? x.strip : x.to_i
    end
    # skip No Nationality etc.
    next if countries[row[0]].nil?
    item = {}
    row.each_with_index do |cell, i|
      item[header[i]] = cell
    end
    item[:Year] = year
    item[:latitude] = countries[item[:name]][:latitude]
    item[:longitude] = countries[item[:name]][:longitude]
    body << item
  end
end

# output
headers << :Year
headers << :latitude
headers << :longitude
h = headers.uniq
remove_headers = ['Total Visas', 'BCC']
remove_headers.each do |r|
  h.delete(r)
end
puts h.to_csv
body.each do |item|
  row = []
  h.each do |key|
    next if remove_headers.include?(key)
    row << item[key]
  end
  puts row.to_csv
end
