class UserDevice
  include Mongoid::Document
  include Mongoid::Timestamps
  field :device_type, type: String
  field :device_token, type: String
  field :user_id, type: Integer
  belongs_to :user, optional: true
end
