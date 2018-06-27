module TwilioSms

  def self.send_otp(phone, content)
    twilio_sid = "AC55732aedd35186f7caa85d360e5dbd01"
      twilio_token = "c575e7358ce88ba822c387bdf2925921"
      twilio_phone_number = "+1929-377-1326"
      begin
      @twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token

      @twilio_client.api.account.messages.create(
      :from => "+1929-377-1326",
      :to =>phone,
      :body=> content
      
      )
      rescue Twilio::REST::TwilioError => e
         return e.message
      end
      return "send"
     # rescue Twilio::REST::RequestError => e
  end
end

