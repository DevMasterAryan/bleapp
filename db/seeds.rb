
require 'csv'    

csv_text = File.read('./devices.csv')
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  Device.create!(row.to_hash)
end