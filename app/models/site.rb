class Site
  include Mongoid::Document
  include Geocoder::Model::Mongoid

  field :site_name, type: String
  field :location_address, type: String
  field :address, type: String
  field :lat, type: Float
  field :long, type: Float
  # field :coordinates, :type => Array
  # field :longitude, :type=> Float
  # field :latitude, :type=> Float

  has_many :devices

  # geocoded_by :address
  # reverse_geocoded_by :coordinates
  # after_validation :reverse_geocode, if: ->(obj){ obj.coordinates.present? }
  # after_validation :geocode, if: ->(obj){ obj.address.present? }

  # index({ geo: "2dsphere" })
  
  def self.search lati, longi
    result = Array.new
    self.all.each do |position|
      lat = position.lat
      long = position.long
      distance_in_km = Geocoder::Calculations.distance_between([lati,longi], [lat,long]) * 1.60934
      result << position if distance_in_km < 3
    end
    result
  end
end
