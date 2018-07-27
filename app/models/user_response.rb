class UserResponse
  include Mongoid::Document
  field :user_id, type: Integer
  field :billing_id, type: Integer
  field :rating, type: String
  field :help_id, type: String
  field :feedback, type:String

  belongs_to :user
end
