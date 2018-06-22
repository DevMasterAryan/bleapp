require 'twilio-ruby'
class Api::V1::PhoneVerificationsController < ApplicationController
  skip_before_action :verify_authenticity_token,only: [:voice,:processs], :raise => false
  after_action :set_header

  def voice
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.say('Your   otp   is   4   1   2   5.', voice: 'alice')
    end
    render xml: response.to_s
  end

  def processs
      make_call
  end

  private

  def from
    #phone number given by twilio
    "+18555728559"
  end

  def to
    "+919773978798"
  end

  def make_call
    twilio_client.calls.create( from: from, to: to, url: "http://bd33e718.ngrok.io/phone_verifications/voice")#, url: callback_url)
  end

  def twilio_client
    @twilio ||= Twilio::REST::Client.new("ACf786a64203b2524f8ee2878ee632bbe7",
                                         "0f53e378507e1543cd5e2ddfcf5389a1")
  end

  def set_header
    response.headers["Content-Type"] = "text/xml"
  end

  def render_twiml(response)
    render text: response.text
  end

end

