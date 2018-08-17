class UserPaymentMethod
  include Mongoid::Document
  field :method, type: Array
  field :user_id, type: String

  belongs_to :user
end
