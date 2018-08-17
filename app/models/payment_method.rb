class PaymentMethod
  include Mongoid::Document
  field :name, type: String
end
