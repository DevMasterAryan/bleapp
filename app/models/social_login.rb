class SocialLogin
  include Mongoid::Document
  include Mongoid::Timestamps
  field :provider_id, type: String
  field :provider, type: String
  field :user_id, type: Integer
  belongs_to :user
end
