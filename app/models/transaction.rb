class Transaction
  include Mongoid::Document
  include Mongoid::Timestamps
  # field :session_id, type: Integer
  # field :billing_id, type: Integer
  # field :method_of_payment, type: String
  # field :transaction_id, type: String
  # field :payment_time_stamp, type: Time
  # field :package_id, type: Integer
  # field :user_start_time_stamp, type: Time
  field :amount, type: Float
  field :transaction_id, type: String
  field :status, type: Mongoid::Boolean, default: false
  has_one :billing, dependent: :destroy
end
