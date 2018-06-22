class Session
  include Mongoid::Document
  include Mongoid::Timestamps
  field :session_ts, type: Time
  field :user_id, type: Integer
  field :device_batterry_start, type: Time
  field :site_id, type: Integer
  field :device_id, type: Integer

  belongs_to :user
  belongs_to :device
end