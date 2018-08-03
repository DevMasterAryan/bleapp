class UserFeedback
  include Mongoid::Document
  field :help_id, type: String
  field :user_id, type: Integer
  field :site_id, type: Integer
  field :rating, type: Integer, default: 0
  field :rating_status, type: Boolean, default: false
end
