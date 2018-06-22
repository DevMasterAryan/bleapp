require 'twilio-ruby'
class Api::V1::PhoneVerificationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  after_action :set_header

  def voice
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.say("Welcome,,to,,wavedio,,Your,,otp,,is,,#{params[:otp].split('').first},,#{params[:otp].split('').second},,#{params[:otp].split('').third},,#{params[:otp].split('').fourth},, Thank,,You", voice: 'alice')
      r.hangup
    end
    render xml: response.to_s
  end


  private

  def set_header
    response.headers["Content-Type"] = "text/xml"
  end

  def render_twiml(response)
    render text: response.text
  end

end

