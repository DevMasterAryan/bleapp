class Device
  include Mongoid::Document
  field :device_id, type: Integer
  field :qr_code, type: Integer
  field :bluetooth_id, type: Integer
  field :id_o, type: Integer
end
