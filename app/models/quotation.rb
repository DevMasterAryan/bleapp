class Quotation
  include Mongoid::Document
  include Mongoid::Timestamps
 
  field :site_id, type: String
  field :device_quantity, type: String
  field :hub_quantity, type: String
  field :one_time_retail_fee, type: String
  field :manager_approval, type: String
  field :qt_approval_date, type: Time
  
end
