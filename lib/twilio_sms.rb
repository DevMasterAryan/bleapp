module TwilioSms

  def self.send_otp(phone, content)
    twilio_sid = "ACf786a64203b2524f8ee2878ee632bbe7"
      twilio_token = "0f53e378507e1543cd5e2ddfcf5389a1"
      twilio_phone_number = "+18555728559"
      begin
      @twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token

      @twilio_client.api.account.messages.create(
      :from => "+18555728559",
      :to => phone,
      :body=> content
      
      )
      rescue Twilio::REST::TwilioError => e
         return e.message
      end
      return "send"
     # rescue Twilio::REST::RequestError => e
  end
end

