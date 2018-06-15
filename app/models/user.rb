require "active_model_otp"
class User
  include ActiveModel::OneTimePassword 
  include Mongoid::Document
  include Mongoid::Timestamps
  has_one_time_password

  field :first_name, :type => String
  field :last_name, :type => String
  field :e_mail, :type => String
  field :mobile_no, :type => String
  field :login_method, :type => String
  field :first_login_date, :type => DateTime
  field :last_login_date, :type => DateTime
  field :logged_in, :type => Boolean
  field :otp_secret_key, :type => String
end
