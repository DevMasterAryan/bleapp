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
  belongs_to :transaction
  belongs_to :session
  belongs_to :package
  belongs_to :user
end

