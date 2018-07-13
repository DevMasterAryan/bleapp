class Device
  include Mongoid::Document
  include Mongoid::Timestamps
  field :device_id, type: Integer
  field :qr_code, type: Integer
  field :bluetooth_id, type: Integer
  field :id_o, type: Integer
  field :location_id, type: Integer
  field :stolen, type: Mongoid::Boolean, default: false
  field :mac_address, type: String
  field :identifier, type: String
  field :device, type: String
  field :device_status, type: String
  field :site_display_name, type: Boolean, default: false
  field :ido_old, type: String 
  field :ido_new, type: String 
  belongs_to :location
  has_one :session, dependent: :destroy
end
