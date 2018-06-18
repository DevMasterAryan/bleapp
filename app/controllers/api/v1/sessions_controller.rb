require 'twilio_sms.rb'

class Api::V1::SessionsController < ApplicationController
	skip_before_action :verify_authenticity_token,only: [:login,:verify_otp]

	def login
	    @otp  = User.generate_otp
		if @user = User.where(mobile: params[:user][:mobile])&.first
			@user.update(otp: @otp)
			otp = TwilioSms.send_otp(@user.mobile,@otp)
			if otp == "send"
				render json: {responseCode: 200, responseMessage: "OTP sent successfully."}
			else
				render json: {responseCode: 500, responseMessage: "Something went wrong."}
			end
		else
			@user =  User.new(mobile: params[:user][:mobile],otp: @otp)
			if @user.save
				otp = TwilioSms.send_otp(@user.mobile,@otp)
				if otp == "send"
					render json: {responseCode: 200, responseMessage: "OTP sent successfully."}
				else
					render json: {responseCode: 500, responseMessage: "Something went wrong."}
				end
			else
				render json: {responseCode: 500, responseMessage: "Something went wrong." }
			end
		end		
	end

	def verify_otp
		@user  = User.where(mobile: params[:mobile], otp: params[:otp]).first
		if @user.present?
			render json: {responseCode: 200, responseMessage: "Login successfully.",access_token: @user.access_token }
		else
			render json: {responseCode: 500, responseMessage: "OTP mismatch."}
		end
		
	end

end
