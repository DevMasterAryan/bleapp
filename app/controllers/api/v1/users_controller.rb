class Api::V1::UsersController < ApplicationController
	skip_before_action :verify_authenticity_token,only: [:apply_credit,:charge_history,:user_last_charge]
	before_action :authenticate,only: [:apply_credit,:charge_history,:user_last_charge]

	def apply_credit
		@package  = Package.find_by(id: params["package_id"])
		if params["mop"]=="credit"
		if !@api_current_user.credit.nil? and @api_current_user&.credit >= @package.package_value
			@remaining_credit = @api_current_user&.credit -  @package.package_value
			@api_current_user.update(credit: @remaining_credit)
			@transaction = Transaction.create(transaction_id: "", status: true, amount: @package&.package_value   )
			@api_current_user.billings.new(method_of_payment: "Credit",session_id: @api_current_user.sessions.last.id, package_id: @package.id,
				usage_start_ts: DateTime.now,usage_end_ts: DateTime.now + @package&.package_time.minutes, transaction_id: @transaction.id).save(validate: false)
			return render json: {responseCode: 200, responseMessage: "Your credit applied.", remaining_credit: @remaining_credit}
		else
			return render json: {responseCode: 500, responseMessage: "Your credit is not enough."}
		end
        elsif params["mop"]=="payment"
          @transaction = Transaction.new(transaction_id: Digest::SHA256.hexdigest(Time.now.to_s), status: true, amount: @package&.package_value)
          if @transaction.save
				@billing = @api_current_user.billings.new(method_of_payment: "Card",session_id: @api_current_user.sessions.last.id, package_id: @package.id,
				usage_start_ts: DateTime.now,usage_end_ts: DateTime.now+@package&.package_time.minutes,transaction_id: @transaction.id )
				if @billing.save
					return render json: {responseCode: 200, responseMessage: "Transaction successful."}
				else
					return render json: {responseCode: 200, responseMessage: "Something went wrong."}
				end
			else
				return render json: {responseCode: 200, responseMessage: "Something went wrong."}
			end   	 
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
			return render json: {responseCode: 200, responseMessage: "History not found.", charge_history: []}
		end
	end

	def user_last_charge
		@additional_topic = StaticContent.where("additional"=> true)
        additional_topic = []
			@additional_topic.each do |at|
				additional_topic << {id: at&.id&.as_json["$oid"] || "", title: at&.title, content:  at&.content}
			end
		@last_charge = @api_current_user&.billings&.last

		if @last_charge.present?
			return render json: {responseCode: 200, last_charge: {location:@last_charge&.session&.device&.location&.name || " ",date_time: @last_charge.created_at&.strftime("%d-%m-%Y %H:%M:%S") || "",package_time: @last_charge&.package&.package_time || "",package_value: @last_charge&.package&.package_value, status: DateTime.now > @last_charge.usage_end_ts ? "Over": "Left" }, additional_topic: additional_topic}
		else
			return render json: {responseCode: 200, responseMessage: "No charge found.", additional_topic: additional_topic}
		end		

	end

	
end
