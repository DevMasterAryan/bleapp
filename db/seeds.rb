
require 'csv'    

csv_text = File.read('./public/devices.csv')
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  Device.create!(row.to_hash)
end


csv_text = File.read('./public/packages.csv')
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  Package.create!(row.to_hash)
end


csv_text = File.read('./public/static_contents.csv')
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  StaticContent.create!(row.to_hash)
end


