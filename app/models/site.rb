class Site
  include Mongoid::Document
  field :site_name, type: String
  field :location_address, type: String
  field :lat, type: String
  field :long, type: String

  has_many :devices
end
