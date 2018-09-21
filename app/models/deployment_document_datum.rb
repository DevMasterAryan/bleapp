class DeploymentDocumentDatum
  include Mongoid::Document
  include Mongoid::Timestamps
  field :quotation_id, type: String
  field :site_id, type: String
  field :site_name, type: String
  field :site_location, type: String 
  field :quotation_date, type: Time
  field :device_id, type: Array, default: [] 
  field :device_type, type: Array, default: []
  field :attachment, type: String
  field :d3_id, type: String
  field :d3_creation_date, type: Time
  field :wh_pickup_date, type: Time

end
