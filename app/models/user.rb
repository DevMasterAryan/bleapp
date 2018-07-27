require "active_model_otp"
require 'twilio_sms.rb'
require 'twilio-ruby'
require 'open-uri'
class User
  include ActiveModel::OneTimePassword 
  include Mongoid::Document
  include Mongoid::Timestamps
  has_one_time_password
  mount_uploader :image, AvatarUploader

  field :first_name, type: String
  field :last_name, type: String
  field :email, type: String
  field :mobile, type: String
  field :login_method, type: String
  field :first_login_date, type: Time
  field :last_login_date, type: Time
  field :logged_in, type: String
  field :image, type: String
  field :user_lock, type: Mongoid::Boolean
  field :credit, type: Float, default: 0.0
  field :promotion, type: String
  field :access_token, type: String
  field :otp, type: Integer
  field :otp_secret_key, :type => String
  field :provider_id, :type => String
  field :provider, :type=> String
  field :last_login, :type=> Time
  field :promotions, :type=> Integer, default: 0
  field :lat, :type=> String
  field :long, :type=> String
  field :imei, :type=> String
  field :ip_address, :type=> String
  field :location, :type=> String
  field :mobile_phone_model, :type=> String
  field :location, :type=> String 
  field :logged_in, :type=> Boolean, default: false
  field :otp_count, :type=> Integer, default: 0

  
  before_create :generate_access_token


  has_many :billings, dependent: :destroy
  has_many :sessions, dependent: :destroy
  has_many :social_logins, dependent: :destroy
  has_many :helps, dependent: :destroy
  has_many :user_devices, dependent: :destroy
  



  def register_device  device_type, device_token
    self.user_devices.find_or_create_by(device_type: device_type, device_token: device_token)
  end


  def self.generate_otp
   otp = [*1000..9999].sample
  end

  def self.call_verification(user)
    begin
      otp = User.generate_otp
      user.update(otp: otp)
      response = open("https://2factor.in/API/V1/b3e8209b-7f80-11e8-a895-0200cd936042/VOICE/#{user.mobile}/#{otp}")
      # @twilio ||= Twilio::REST::Client.new("AC55732aedd35186f7caa85d360e5dbd01","c575e7358ce88ba822c387bdf2925921")
      # @twilio.calls.create( from: "+1929-377-1326", to: user.mobile, url: "https://wavedio.herokuapp.com/phone_verifications/voice?otp=#{otp}")
    rescue Exception => e
      
    end
  end

  def twilio_client
    @twilio ||= Twilio::REST::Client.new("AC55732aedd35186f7caa85d360e5dbd01","c575e7358ce88ba822c387bdf2925921")
  end
  private

  def generate_access_token
    self.access_token = Digest::SHA256.hexdigest(Time.now.to_s)      
  end



end
