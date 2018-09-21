class Warehouse
  include Mongoid::Document
  include Mongoid::Timestamps
   
  field :device_id,  type: String
  field :qr_code, type: String
  field :product_type, type: String
  field :warehouse_received_date, type: Time
  field :iqc_report, type: String
  field :device_status, type: String 
end
