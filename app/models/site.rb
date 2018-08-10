class Site
  include Mongoid::Document
  include Geocoder::Model::Mongoid

  field :site_name, type: String
  field :location_address, type: String
  field :address, type: String
  field :lat, type: String
  field :long, type: String
  field :coordinates, :type => Array

  has_many :devices

  geocoded_by :address
  reverse_geocoded_by :coordinates
  after_validation :reverse_geocode, if: ->(obj){ obj.coordinates.present? }
  after_validation :geocode, if: ->(obj){ obj.address.present? }

  index({ coordinates: "2d" },{"background": true})

end
