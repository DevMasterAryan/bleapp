class Api::V1::TransactionsController < ApplicationController
	skip_before_action :verify_authenticity_token,only: [:package_payment]
	before_action :authenticate,only: [:package_payment]

	def package_payment
		@package  = Package.find_by(id: params["package_id"])
		if @package.present?
			@transaction = Transaction.new(transaction_id: Digest::SHA256.hexdigest(Time.now.to_s), status: true, amount: @package&.package_value   )
			if @transaction.save
				@billing = @api_current_user.billings.new(method_of_payment: "Card",session_id: @api_current_user.sessions.last.id, package_id: @package.id,
				usage_start_ts: DateTime.current,usage_end_ts: DateTime.current+@package&.package_time.minutes,transaction_id: @transaction.id )
				if @billing.save
					return render json: {responseCode: 200, responseMessage: "Transaction successful."}
				else
					return render json: {responseCode: 200, responseMessage: "Something went wrong."}
				end
			else
				return render json: {responseCode: 200, responseMessage: "Something went wrong."}
			end
		else
			return render json: {responseCode: 200, responseMessage: "Package not found."}
		end
		
	end
end
