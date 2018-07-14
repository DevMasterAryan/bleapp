class Billing
  include Mongoid::Document
  include Mongoid::Timestamps
  field :session_id, type: String
  field :method_of_payment, type: String
  field :transaction_id, type: String
  field :payment_time_stamp, type: Time
  field :package_id, type: String
  field :usage_start_ts, type: Time
  field :usage_end_ts, type: Time
  field :user_id, type: String
  field :rating, type: Integer
  field :help_id, type: String
  field :help_status, type: String
  field :payment_status, type: Boolean, default: false
  field :device_battery_ts15, type: Time
  field :device_battery_ts30, type: Time
  field :device_battery_ts45, type: Time
  field :device_battery_ts60, type: Time
  field :amount, type: Float
  belongs_to :transaction, optional: true
  belongs_to :session
  belongs_to :package
  belongs_to :user
end

