class AdminUser
  include Mongoid::Document
  include RememberMe::Model
  include ActiveModel::SecurePassword
  field :email, type: String
  field :password_digest, type: String
  field :remember_created_at,type: Time
  field :type, type: String
  field :reset_digest, type: String
  field :reset_created_at, type: Time
  has_secure_password
end
