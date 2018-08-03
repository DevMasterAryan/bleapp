class UserResponse
  include Mongoid::Document

  field :user_id, type: Integer
  field :billing_id, type: Integer
  field :rating, type: String
  field :help_id, type: Array, default: []
  field :feedback, type:String
  field :site_id, type:Integer
  field :rating_status, type: Boolean, default: false
  # serialize :help_id
  belongs_to :user
end
