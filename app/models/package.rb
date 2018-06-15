class Package
  include Mongoid::Document
  field :package_id, type: Integer
  field :package_time, type: Integer
  field :package_value, type: Float
end
