require "active_model_otp"
require 'twilio_sms.rb'

class User
  include ActiveModel::OneTimePassword 
  include Mongoid::Document
  include Mongoid::Timestamps
  has_one_time_password

  field :first_name, type: String
  field :last_name, type: String
  field :email, type: String
  field :mobile, type: String
  field :login_method, type: String
  field :first_login_date, type: Time
  field :last_login_date, type: Time
  field :logged_in, type: String
  field :user_lock, type: Mongoid::Boolean
  field :credit, type: Float
  field :promotion, type: String
  field :access_token, type: String
  field :otp, type: Integer
  field :otp_secret_key, :type => String
  field :provider_id, :type => String
  field :provider, :type=> String
  
  before_create :generate_access_token



  def self.generate_otp
   otp = [*1000..9999].sample
  end

  private
  def generate_access_token
    self.access_token = Digest::SHA256.hexdigest(Time.now.to_s)      
  end

end
