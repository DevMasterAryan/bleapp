class Api::V1::UsersController < ApplicationController
	skip_before_action :verify_authenticity_token,only: [:apply_credit,:charge_history,:user_last_charge]
	before_action :authenticate,only: [:apply_credit,:charge_history,:user_last_charge]

	def apply_credit
		@package  = Package.find_by(id: params["package_id"])
		if !@api_current_user.credit.nil? and @api_current_user&.credit >= @package.package_value
			@remaining_credit = @api_current_user&.credit -  @package.package_value
			@api_current_user.update(credit: @remaining_credit)
			@api_current_user.billings.new(method_of_payment: "Credit",session_id: @api_current_user.sessions.last.id, package_id: @package.id,
				usage_start_ts: DateTime.now,usage_end_ts: DateTime.now + @package&.package_time.minutes).save(validate: false)
			return render json: {responseCode: 200, responseMessage: "Your credit applied."}
		else
			return render json: {responseCode: 500, responseMessage: "Your credit is not enough."}
		end		
	end

	def charge_history
		@billings = @api_current_user.billings
		if @billings.present?
		    @billings_data = []
		    @billings.each do |billing|
		   		@billings_data << {location: billing&.session&.device&.location&.name || "",billing_ts: billing&.created_at&.strftime("%d-%m-%Y %H:%M:%S") || "",package_time: billing&.package&.package_time || ""}
		    end
		    return render json: {responseCode: 200, charge_history: @billings_data}
		else
			return render json: {responseCode: 200, charge_history: "History not found."}
		end
	end

	def user_last_charge
		@last_charge = @api_current_user&.billings&.last
		if @last_charge.present?
			return render json: {responseCode: 200, last_charge: {location:@last_charge&.session&.device&.location&.name || " ",date_time: @last_charge.created_at&.strftime("%d-%m-%Y %H:%M:%S") || "",package_time: @last_charge&.package&.package_time || ""}}
		else
			return render json: {responseCode: 200, responseMessage: "No charge found."}
		end		
	end

	
end
