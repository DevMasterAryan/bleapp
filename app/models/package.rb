class Package
  include Mongoid::Document
  include Mongoid::Timestamps
  field :package_id, type: Integer
  field :package_time, type: Integer
  field :package_value, type: Float
  field :package_gst, type: Float
  field :package_final, type: Float
  has_many :billings, dependent: :destroy
end
