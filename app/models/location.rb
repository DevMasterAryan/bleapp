class Location
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :lat, type: String
  field :long, type: String
  has_many :devices, dependent: :destroy
end
