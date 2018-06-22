class Api::V1::UsersController < ApplicationController
	skip_before_action :verify_authenticity_token,only: [:apply_credit,:charge_history,:user_last_charge]
	before_action :authenticate,only: [:apply_credit,:charge_history,:user_last_charge]

	def apply_credit
		@package  = Package.find_by(id: params["package_id"])
		if !@api_current_user.credit.nil? and @api_current_user&.credit >= @package.package_value
			@remaining_credit = @api_current_user&.credit -  @package.package_value
			@api_current_user.update(credit: @remaining_credit)
			return render json: {responseCode: 200, responseMessage: "Your credit applied."}
		else
			return render json: {responseCode: 500, responseMessage: "Your credit is not enough."}
		end		
	end

	def charge_history
		@sessions = @api_current_user.sessions
		if @sessions.present?
		    @session_data = []
		    @sessions.each do |session|
		   		@session_data << {session_ts: session&.session_ts || "",device_batterry_start: session&.device_batterry_start || "", created_at: session.created_at }
		    end
		    return render json: {responseCode: 200, charge_history: @session_data}
		else
			return render json: {responseCode: 200, charge_history: "History not found."}
		end
	end

	def user_last_charge
		@last_charge = @api_current_user&.sessions&.last
		if @last_charge.present?
			return render json: {responseCode: 200, last_charge: {location:@last_charge.device&.location&.name || " ",date_time: @last_charge.created_at&.strftime("%d-%m-%Y %H:%M:%S") || ""}}
		else
			return render json: {responseCode: 200, responseMessage: "No charge found."}
		end		
	end

	
end
