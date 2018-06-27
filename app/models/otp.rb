class Otp
  include Mongoid::Document
  include Mongoid::Timestamps
  field :otp, type: String
  field :user_id, type: Integer
  field :mobile, type: String
end
