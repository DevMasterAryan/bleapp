class Device
  include Mongoid::Document
  include Mongoid::Timestamps
  field :device_id, type: Integer
  field :qr_code, type: Integer
  field :bluetooth_id, type: Integer
  field :id_o, type: Integer
  field :location_id, type: Integer
  field :stolen, type: Mongoid::Boolean, default: false
  belongs_to :location
  has_one :session, dependent: :destroy
end
