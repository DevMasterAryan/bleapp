require "active_model_otp"
require 'twilio_sms.rb'
require 'twilio-ruby'
require 'open-uri'
class User
  require './lib/encryption_new_pg.rb'
  include EncryptionNewPG
  extend PaytmHelper
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
  field :image, type: String
  field :user_lock, type: Mongoid::Boolean
  field :credit, type: Float, default: 0.0
  field :promotion, type: Integer, default: 0
  field :access_token, type: String
  field :otp, type: Integer
  field :otp_secret_key, :type => String
  field :provider_id, :type => String
  field :provider, :type=> String
  field :last_login, :type=> Time
  field :promotion_count, :type=> Integer, default: 0
  field :lat, :type=> String
  field :long, :type=> String
  field :imei, :type=> String
  field :ip_address, :type=> String
  field :mobile_phone_model, :type=> String
  field :location, :type=> String 
  field :logged_in, :type=> Boolean, default: false
  field :otp_count, :type=> Integer, default: 0
  field :paytm_mobile, :type=> String, default: ""
  field :paytm_access_token, :type=> String, default: ""
  field :paytm_access_token_exp_date, type: Time

  
  before_create :generate_access_token


  has_many :billings, dependent: :destroy
  has_many :sessions, dependent: :destroy
  has_many :social_logins, dependent: :destroy
  has_many :helps, dependent: :destroy
  has_many :user_devices, dependent: :destroy

  has_many :user_promotions
  has_many :user_feedbacks, dependent: :destroy

  has_one :user_payment_method, dependent: :destroy

  # has_many :promotions, through: :user_promotions
  def promotions
    # Promotion.in(id: user_promotions.pluck(:promotion_id))
    Promotion.where({'id'=> {'$in'=> UserPromotion.pluck(:promotion_id)}, 'end_date'=> {'$gt'=> DateTime.now}, 'start_date'=> {'$lt'=> DateTime.now}})
  end



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
      mobile = user.mobile
      mobile.slice!(0,3)
      response = open("https://2factor.in/API/V1/b3e8209b-7f80-11e8-a895-0200cd936042/VOICE/#{mobile}/#{otp}")
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

  def self.checksum(api_current_user,txn_amount,type,order_id = nil) 
  if type == "consult"  
      v = api_current_user.paytm_access_token
      txn_amount = txn_amount
      @paramList = '{"userToken":"'+v+'","totalAmount":"'+txn_amount+'''","mid":"Wavedi71402481589558","amountDetails": {"others": "","food": ""}}'
      @checksum_hash=generate_checksum()  
    else
      @paramList = {"MID": "Wavedi71402481589558","ReqType": "WITHDRAW","TxnAmount": "#{txn_amount}","AppIP": "127.0.0.1","OrderId": "#{order_id}","Currency": "INR","DeviceId": "#{api_current_user.paytm_mobile}","SSOToken": "#{api_current_user.paytm_access_token}","PaymentMode": "PPI","CustId": "1040","IndustryType": "Retail109","Channel": "WAP","AuthMode": "USRPWD"}
      p @paramList
      # @checksum=generate_checksum() 
      new_pg_checksum(@paramList,"MUBUL!hKGtxvcmXM") 
    end
  end

  def self.paytm_withdraw_api(api_current_user,txn_amount)
    begin
      order_id = DateTime.now.to_i
      checksum = self.checksum(api_current_user,txn_amount,"",order_id)
      response =  eval(ActiveSupport::JSON.decode(`curl -X POST -k -H 'Content-Type: application/json' -i 'https://securegw.paytm.in/paymentservices/HANDLER_FF/withdrawScw' --data '{"MID": "Wavedi71402481589558","ReqType": "WITHDRAW","TxnAmount": "#{"txn_amount"}","AppIP": "127.0.0.1","OrderId": "#{order_id}","Currency": "INR","DeviceId": "#{api_current_user.paytm_mobile}","SSOToken": "#{api_current_user.paytm_access_token}","PaymentMode": "PPI","CustId": "1040","IndustryType": "Retail109","Channel": "WAP","AuthMode": "USRPWD","CheckSum":  "#{checksum}"}'`.to_json).split("\r\n\r\n")[1]) 
      return resonse
    rescue Exception => e
      return false
    end
    
  end



end


