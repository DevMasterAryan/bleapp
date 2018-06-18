class Api::V1::UsersController < ApplicationController
	skip_before_action :verify_authenticity_token,only: [:apply_credit]
	before_action :authenticate,only: [:apply_credit]

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

	
end
