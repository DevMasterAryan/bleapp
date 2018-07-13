class Session
  include Mongoid::Document
  include Mongoid::Timestamps
  field :session_ts, type: Time
  field :user_id, type: Integer
  field :device_battery_start, type: Time
  field :site_id, type: Integer
  field :device_id, type: Integer
  field :session_start_ts, type: Time
  field :session_end_ts, type: Time

  belongs_to :user
  belongs_to :device
  has_one :billing, dependent: :destroy
end
