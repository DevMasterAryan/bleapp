
require 'csv'    

csv_text = File.read('/devices.csv')
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  Device.create!(row.to_hash)
end


csv_text = File.read('/packages.csv')
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  Package.create!(row.to_hash)
end


csv_text = File.read('/static_contents.csv')
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  StaticContent.create!(row.to_hash)
end


