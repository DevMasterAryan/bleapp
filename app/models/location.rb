class Location
  include Mongoid::Document
  field :name, type: String
  field :lat, type: String
  field :long, type: String
  has_many :devices
end
