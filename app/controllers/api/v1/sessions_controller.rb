require 'twilio_sms.rb'

class Api::V1::SessionsController < ApplicationController
	skip_before_action :verify_authenticity_token,only: [:login,:verify_otp,:social_login,:call_verification]

	def login
	    @otp  = User.generate_otp
		if @user = User.where(mobile: params[:user][:mobile])&.first
			@user.update(otp: @otp)
			otp = TwilioSms.send_otp(@user.mobile,@otp)
			if otp == "send"
				render json: {responseCode: 200, responseMessage: "OTP sent successfully."}
			else
				render json: {responseCode: 500, responseMessage: "Something went wrong.",otp: @otp}
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

	def social_login
	  	begin	  	
		    @user = User.find_or_create_by(email: params[:user][:email]) || User.find_or_create_by(mobile: params[:user][:mobile])
			
			if @user.present?
		       @user.attributes = {email: params[:user][:email], first_name: params[:user][:first_name], last_name: params[:user][:last_name], :remote_image_url=> params[:user][:image]}
		       @user.save
		       @user.reload
		       @user.social_logins.find_or_create_by(provider_id: params[:user][:provider_id], provider: params[:user][:provider])
			   return render json: {responseCode: 200, responseMessage: "Login successfully." ,access_token: @user.access_token, first_name: @user&.first_name, last_name: @user.last_name, image: @user&.image&.url}
			end	 		
	  	rescue Exception => e
	    	return render json: {responseCode: 500, responseMessage: "Something went wrong try again later."}  	
	  	end
	end

	def call_verification
		@user = User.find_by(:mobile=>params[:mobile])
		if @user.present?
			User.call_verification(@user)
			return render json: {responseCode: 200, responseMessage: "Calling."}
		else
			return render json: {responseCode: 500, responseMessage: "User not found."}
		end
		
	end

end
