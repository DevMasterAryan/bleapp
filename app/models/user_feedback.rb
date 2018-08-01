class UserFeedback
  include Mongoid::Document
  field :help_id, type: String
  field :user_id, type: Integer
  field :site_id, type: Integer
end
