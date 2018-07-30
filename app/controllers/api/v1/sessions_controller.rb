require 'twilio_sms.rb'
require 'open-uri'

class Api::V1::SessionsController < ApplicationController
	skip_before_action :verify_authenticity_token,only: [:login,:verify_otp,:social_login,:call_verification, :logout]
    before_action :authenticate,only: [:logout]

	def login
	    @otp  = User.generate_otp
	    @user = User.find_by(mobile: params[:user][:mobile])
		if @user.present?
			@user.attributes = {email: params[:user][:email], first_name: params[:user][:first_name], last_name: params[:user][:last_name], :remote_image_url=> params[:user][:image], :last_login=> DateTime.current, imei: params[:user][:imei], mobile_phone_model: params[:user][:mobile_phone_model], logged_in: true}
		    @user.save
			@user.register_device(params[:user][:device_type], params[:user][:device_token])
			if @user.billings.last.present? and (DateTime.current < @user.billings.last.usage_end_ts)
				render json: {responseCode: 200, responseMessage: "Login successfully.",access_token: @user.access_token, end_time: @user&.billings&.last&.usage_end_ts&.to_i || "", credit: @user.credit, mop: @user&.billings&.last&.method_of_payment,site_display_name: @user&.billings&.last&.session&.device&.site_display_name, site_name: @user&.billings&.last&.session&.device&.site_display_name? ? @user&.billings&.last&.session&.device&.location&.name : "",billing_id: @user&.billings&.last&.id&.as_json["$oid"], promotion: @user.promotion}
			else
				return render json: {responseCode: 200, responseMessage: "Please try some other mode of login."} if @user.otp_count >=3 && params[:resend_otp].present?
				@user.update(otp: @otp)
				# otp = TwilioSms.send_otp(@user.mobile,@otp)
				response = open("https://2factor.in/API/V1/b3e8209b-7f80-11e8-a895-0200cd936042/SMS/#{@user.mobile}/#{@otp}")
				# if otp == "send"
				if response.status.first == "200"
					render json: {responseCode: 200, responseMessage: "OTP sent successfully."}
				else
					render json: {responseCode: 500, responseMessage: "Something went wrong.",otp: @otp}
				end
			end
		else
			@user =  User.new(mobile: params[:user][:mobile],otp: @otp)
			if @user.save
				return render json: {responseCode: 200, responseMessage: "Please try some other mode of login."} if @user.otp_count >=3 && params[:resend_otp].present?
				 # otp = TwilioSms.send_otp(@user.mobile,@otp)
				response = open("https://2factor.in/API/V1/b3e8209b-7f80-11e8-a895-0200cd936042/SMS/#{@user.mobile}/#{@otp}")
				if response.status.first == "200"
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
			@user.register_device(params[:device_type], params[:device_token])
			# @user.update(last_login: DateTime.now, mobile_phone_model: params[:user][:mobile_phone_model])
			@user.attributes = {email: params[:email], first_name: params[:first_name], last_name: params[:last_name], :remote_image_url=> params[:image], :last_login=> DateTime.current, imei: params[:imei], mobile_phone_model: params[:mobile_phone_model], logged_in: true}
		    @user.save
			render json: {responseCode: 200, responseMessage: "Login successfully.",access_token: @user&.access_token || "",mop: @user.billings.present? ? @user&.billings&.last&.method_of_payment : "",site_display_name: @user.billings.present? ? @user&.billings&.last&.session&.device&.site_display_name : "", site_name: @user.billings.present? ? @user&.billings&.last&.session&.device&.site_display_name? ? @user&.billings&.last&.session&.device&.location&.name : "" : "", billing_id: @user.billings.present? ? @user&.billings&.last&.id&.as_json["$oid"] : "", promotion: @user&.promotion || "" }
		else
			render json: {responseCode: 500, responseMessage: "OTP mismatch."}
		end
		
	end

	def social_login
	  	begin	  	
		    @user = User.find_or_create_by(email: params[:user][:email]) || User.find_or_create_by(mobile: params[:user][:mobile])
			
			if @user.present?
			   @user.register_device(params[:user][:device_type], params[:user][:device_token])
		       @user.attributes = {email: params[:user][:email], first_name: params[:user][:first_name], last_name: params[:user][:last_name], :remote_image_url=> params[:user][:image], :last_login=> DateTime.current, imei: params[:user][:imei], mobile_phone_model: params[:user][:mobile_phone_model], logged_in: true}
		       @user.save
		       # @user.reload
		       @user = User.find_by(id: @user.id)
		       @social = @user.social_logins.find_or_create_by(provider_id: params[:user][:provider_id], provider: params[:user][:provider])
			   if @user.billings.last.present? and (DateTime.current < @user.billings.last.usage_end_ts)
			     return render json: {responseCode: 200, responseMessage: "Login successfully." ,access_token: @user.access_token, first_name: @user&.first_name, last_name: @user.last_name, image: @user&.image&.url,provider_id: @social&.provider_id, end_time: @user&.billings&.last&.usage_end_ts&.to_i || "", credit: @user&.credit, mop: @user&.billings&.last&.method_of_payment,mop: @user&.billings&.last&.method_of_payment,site_display_name: @user&.billings&.last&.session&.device&.site_display_name, site_name: @user&.billings&.last&.session&.device&.site_display_name? ? @user&.billings&.last&.session&.device&.location&.name : "", billing_id: @user&.billings&.last&.id&.as_json["$oid"], promotion: @user.promotion }
			   else

			   return render json: {responseCode: 200, responseMessage: "Login successfully." ,access_token: @user.access_token, first_name: @user&.first_name, last_name: @user.last_name, image: @user&.image&.url,provider_id: @social&.provider_id, end_time: @user&.billings&.last&.usage_end_ts.to_i || "",mop: @user&.billings&.last&.method_of_payment,site_display_name: @user&.billings&.last&.session&.device&.site_display_name, site_name: @user&.billings&.last&.session&.device&.site_display_name? ? @user&.billings&.last&.session&.device&.location&.name : "", credit: @user&.credit, billing_id: @user&.billings&.last&.id&.as_json["$oid"], promotion: @user.promotion}
			   end
			end	 		
	  	rescue Exception => e
	    	return render json: {responseCode: 500, responseMessage: "Something went wrong try again later."}  	
	  	end
	end

	def logout
	 @api_current_user.update(logged_in: false)
	 @api_current_user.user_devices.destroy_all	
	 render json: {responseCode: 200, responseMessage: "Logout successfully."}
	end

	def call_verification
		@user = User.find_by(:mobile=>params[:mobile])
		if @user.present?
           return render json: {responseCode: 200, responseMessage: "Please try some other mode of login."} if @user.otp_count >=3 && params[:resend_otp].present?


			begin				
				User.call_verification(@user)
			rescue Exception => e
				return render json: {responseCode: 500, responseMessage: "Try again."}
			end
			return render json: {responseCode: 200, responseMessage: "Calling."}
		else
			return render json: {responseCode: 500, responseMessage: "User not found."}
		end
		
	end

end
