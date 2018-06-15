class Session
  include Mongoid::Document
  field :session_ts, type: Time
  field :user_id, type: Integer
  field :device_batterry_start, type: Time
  field :site_id, type: Integer
  field :device_id, type: Integer
end
