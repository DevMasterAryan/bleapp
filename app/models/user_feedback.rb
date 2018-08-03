class UserFeedback
  include Mongoid::Document
  field :help_id,  type: Array, default: []
  field :user_id, type: Integer
  field :site_id, type: Integer
  field :rating, type: Integer, default: 0
  field :session_id, type: Integer
  field :rating_status, type: Boolean, default: false
  field :billing_id, type: Integer
  field :feedback, type: String

  belongs_to :billing, optional: true
  belongs_to :user, optional: true
end
