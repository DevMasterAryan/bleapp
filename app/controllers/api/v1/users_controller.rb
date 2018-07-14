class Api::V1::UsersController < ApplicationController
	skip_before_action :verify_authenticity_token,only: [:apply_credit,:charge_history,:user_last_charge]
	before_action :authenticate,only: [:apply_credit,:charge_history,:user_last_charge]

	def apply_credit
		@package  = Package.find_by(id: params["package_id"])
		@session = Session.find_by(id: params["session_id"])
		# @session.update(device_battery_status: params["device_battery_status"])
		if params["mop"]=="credit"
		if !@api_current_user.credit.nil? and @api_current_user&.credit >= @package.package_value
			@remaining_credit = @api_current_user&.credit -  @package.package_value
			@api_current_user.update(credit: @remaining_credit)
			# @transaction = Transaction.create(transaction_id: "", status: true, amount: @package&.package_value)
			@billing = @api_current_user.billings.new(method_of_payment: "Credit",session_id: @session.id, package_id: @package.id,
				usage_start_ts: DateTime.now,usage_end_ts: DateTime.now + @package&.package_time.minutes, amount: @package&.package_value).save(validate: false)
			@billing.update(transaction_id: credit.to_s+@billing.id.as_json["$oid"])
			return render json: {responseCode: 200, responseMessage: "Your credit applied.", remaining_credit: @remaining_credit, end_time: @api_current_user&.billings&.last&.usage_end_ts&.to_i || "",site_display_name: @api_current_user&.billings&.last&.session&.device&.site_display_name, site_name: @api_current_user&.billings&.last&.session&.device&.site_display_name? ? @api_current_user&.billings&.last&.session&.device&.location&.name : ""}
		else
			return render json: {responseCode: 500, responseMessage: "Your credit is not enough."}
		end
        elsif params["mop"]=="payment"
          # @transaction = Transaction.new(transaction_id: params["transaction_id"], status: true, amount: @package&.package_value)
          # @transaction = Transaction.new(transaction_id: Digest::SHA256.hexdigest(Time.now.to_s), status: true, amount: @package&.package_value)
          # if @transaction.save
				@billing = @api_current_user.billings.new(method_of_payment: "Card",session_id: @api_current_user.sessions.last.id, package_id: @package.id,
				usage_start_ts: DateTime.now,usage_end_ts: DateTime.now+@package&.package_time.minutes,transaction_id: "",amount: @package&.package_value)
				if @billing.save
					return render json: {responseCode: 200, responseMessage: "Transaction successful.", end_time: @api_current_user&.billings&.last&.usage_end_ts&.to_i || ""}
				else
					return render json: {responseCode: 200, responseMessage: "Something went wrong."}
				end
			else
				return render json: {responseCode: 200, responseMessage: "Something went wrong."}
			end   	 
		# end		
	end

	def charge_history
		@billings = @api_current_user&.billings&.reverse
		if @billings.present?
		    @billings_data = []
		    @billings.each do |billing|
		    	# billing.created_at.strftime("%d/%m/%Y")+ " "+"at"+" "+billing.created_at.strftime("%I:%M %p")
		   		@billings_data << {location: billing&.session&.device&.location&.name || "",billing_ts:  billing.created_at.to_i || "",package_time: billing&.package&.package_time || "", active: DateTime.now > billing&.usage_end_ts ? false : true }
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
			# @last_charge.created_at.strftime("%d/%m/%Y")+ " "+"at"+" "+@last_charge.created_at.strftime("%I:%M %p")
			return render json: {responseCode: 200, last_charge: {location:@last_charge&.session&.device&.location&.name || " ",date_time:  @last_charge&.created_at&.to_i|| "",package_time: @last_charge&.package&.package_time || "",package_value: @last_charge&.package&.package_value, active: DateTime.now > @last_charge.usage_end_ts ? false : true }, additional_topic: additional_topic}
		else
			return render json: {responseCode: 200, responseMessage: "No charge found.", additional_topic: additional_topic}
		end		

	end
  
	
end
