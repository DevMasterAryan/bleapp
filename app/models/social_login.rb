class SocialLogin
  include Mongoid::Document
  field :provider_id, type: String
  field :provider, type: String
  field :user_id, type: Integer
end
