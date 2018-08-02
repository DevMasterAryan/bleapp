class Api::V1::UsersController < ApplicationController
	skip_before_action :verify_authenticity_token,only: [:apply_credit,:charge_history,:user_last_charge, :checksum,:billing_not_rated]
	before_action :authenticate,only: [:apply_credit,:charge_history,:user_last_charge,:billing_not_rated, :checksum,:billing_not_rated]
    include PaytmHelper
	def apply_credit
		@package  = Package.find_by(id: params["package_id"])
		@session = Session.find_by(id: params["session_id"])


        #promotion applied
        if params["mop"]=="promotion"
          return render json: {responseCode: 200, responseMessage: "You have not promotion to apply."}  if @api_current_user.promotion<1
          @billing = @api_current_user.billings.new(method_of_payment: "Promotion",session_id: @session.id, package_id: @package.id,usage_start_ts: DateTime.current,usage_end_ts: DateTime.current + @package&.package_time.minutes, amount: @package&.package_value).save(validate: false)
			# @billing.update(transaction_id: credit.to_s+@billing.id.as_json["$oid"])
          @api_current_user.update(promotion: @api_current_user.promotion - 1) 
          return render json: {responseCode: 200, responseMessage: "Your promotion applied.", remaining_credit: @api_current_user.credit, end_time: @api_current_user&.billings&.last&.usage_end_ts&.to_i || "",site_display_name: @api_current_user&.billings&.last&.session&.device&.site_display_name, site_name: @api_current_user&.billings&.last&.session&.device&.site_display_name? ? @api_current_user&.billings&.last&.session&.device&.site_name : "", remaining_promotion: @api_current_user.promotion, billing_id: @billing.id.as_json["$oid"]}
         	 
        end 
        #promotion applied code end
		# @session.update(device_battery_status: params["device_battery_status"])
		if params["mop"]=="credit"
		if !@api_current_user.credit.nil? and @api_current_user&.credit >= @package.package_value
			@remaining_credit = @api_current_user&.credit -  @package.package_value
			@api_current_user.update(credit: @remaining_credit)
			# @transaction = Transaction.create(transaction_id: "", status: true, amount: @package&.package_value)
			@billing = @api_current_user.billings.new(method_of_payment: "Credit",session_id: @session.id, package_id: @package.id,
				usage_start_ts: DateTime.current,usage_end_ts: DateTime.current + @package&.package_time.minutes, amount: @package&.package_value).save(validate: false)
			@billing.update(transaction_id: credit.to_s+@billing.id.as_json["$oid"])
			return render json: {responseCode: 200, responseMessage: "Your credit applied.", remaining_credit: @remaining_credit, end_time: @api_current_user&.billings&.last&.usage_end_ts&.to_i || "",site_display_name: @api_current_user&.billings&.last&.session&.device&.site_display_name, site_name: @api_current_user&.billings&.last&.session&.device&.site_display_name? ? @api_current_user&.billings&.last&.session&.device&.site_name : "", remaining_promotion: @api_current_user.promotion, billing_id: @billing.id.as_json["$oid"]}
		else
			return render json: {responseCode: 500, responseMessage: "Your credit is not enough."}
		end
        elsif params["mop"]=="payment"
                if params[:credit].present?
                     @remaining_credit = @api_current_user.credit - params[:credit].to_i 
                     @api_current_user.update(credit: @remaining_credit)
                end
				@billing = @api_current_user.billings.new(method_of_payment: "Card",session_id: @api_current_user.sessions.last.id, package_id: @package.id,
				usage_start_ts: DateTime.current,usage_end_ts: DateTime.current+@package&.package_time.minutes,transaction_id: "",amount: params[:card].present? ? params[:card] : @package&.package_final)
				if @billing.save
					return render json: {responseCode: 200, responseMessage: "Your credit applied.", remaining_credit: @api_current_user.credit, end_time: @api_current_user&.billings&.last&.usage_end_ts&.to_i || "",site_display_name: @api_current_user&.billings&.last&.session&.device&.site_display_name, site_name: @api_current_user&.billings&.last&.session&.device&.site_display_name? ? @api_current_user&.billings&.last&.session&.device&.site_name : "", remaining_promotion: @api_current_user.promotion, billing_id: @billing.id.as_json["$oid"]}
				else
					return render json: {responseCode: 200, responseMessage: "Something went wrong."}
				end
			else
				return render json: {responseCode: 200, responseMessage: "Something went wrong."}
			end   	 
		# end		
	end

	def charge_history
		@billings = Billing&.where(user_id: @api_current_user).order(created_at: :desc).paginate(:page =>params[:page], :limit => params[:per_page]) 	
		if @billings.present?
		    @billings_data = []
		    @billings.each do |billing|
		    	# billing.created_at.strftime("%d/%m/%Y")+ " "+"at"+" "+billing.created_at.strftime("%I:%M %p")
		   		@billings_data << {location: billing&.session&.device&.location&.name || "",billing_ts:  billing.created_at.to_i || "",package_time: billing&.package&.package_time || "", active: DateTime.current > billing&.usage_end_ts ? false : true, rating: 0, billing_id: billing.id&.as_json["$oid"], package_value: billing.package.package_value,package_gst: billing.package.package_gst, package_final: billing.package.package_final, site_name: billing&.session&.device&.site&.site_name || "", start_time: billing&.usage_start_ts&.to_i, end_time: billing&.usage_end_ts&.to_i }
		    end
		    return render json: {responseCode: 200, charge_history: @billings_data,:pagination=>{page_no: params[:page],per_page: params[:per_page],max_page_size: @api_current_user.billings.count/params[:per_page].to_i+1, total_records: @api_current_user.billings.count}}
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
			return render json: {responseCode: 200, last_charge: {location: @last_charge&.session&.device&.location&.name || "",billing_ts:  @last_charge.created_at.to_i || "",package_time: @last_charge&.package&.package_time || "", active: DateTime.current > @last_charge&.usage_end_ts ? false : true, rating: 0, billing_id: @last_charge.id&.as_json["$oid"], package_value: @last_charge.package.package_value,package_gst: @last_charge.package.package_gst, package_final: @last_charge.package.package_final, site_name: @last_charge&.session&.device&.site&.site_name || "", start_time: @last_charge&.usage_start_ts&.to_i, end_time: @last_charge&.usage_end_ts&.to_i }, additional_topic: additional_topic}
		else
			return render json: {responseCode: 200, responseMessage: "No charge found.", additional_topic: additional_topic}
		end		

	end
    
    def billing_not_rated
    if params[:rating_status].present? && params[:billing_id].present?
    	@billing = Billing.find_by(id: params[:billing_id])
    	@billing.update(rating_status: params[:rating_status])
       return render json: {responseCode: 200, responseMessage: "Status updated successfully."}
    else

       @billings = @api_current_user.billings.where({'created_at' => {'$gt' => Date.today-7.days}, 'rating'=> {'$lt'=> 1},'usage_end_ts'=> {'$lt'=> DateTime.current}, 'rating_status'=> false}).limit(3).map { |r| [billing_id: r.id.as_json["$oid"], site_name: r&.session&.device&.site&.site_name] }.flatten!
      if @billings.present? 
         return render json: {responseCode: 200, responseMessage: "Billing fetched successfully.", billing: @billings} 
      else
         return render json: {responseCode: 200, responseMessage: "No billing found.", billing: []} 
      end 
    end


    end
   
    def checksum
    
        paramList = Hash.new
	    paramList["MID"] = "Wavedi27436137685521"
	    paramList["INDUSTRY_TYPE_ID"] = "Retail"
	    paramList["CHANNEL_ID"] = "WAP"
	    paramList["WEBSITE"] = "APPSTAGING"
	    paramList["ORDER_ID"] = params[:order_id]
	    paramList["CUST_ID"] = @api_current_user.id&.as_json["$oid"]
	    paramList["TXN_AMOUNT"] = params[:txn_amount]
	    paramList["CURRENCY"] = "INR"
	    paramList["MOBILE_NO"] = params[:mobile_no]
	    paramList["REQUEST_TYPE"] = "DEFAULT"
	    paramList["EMAIL"] = params[:email]
	    paramList["THEME"] = params[:theme]
	    paramList["CALLBACK_URL"]  = params[:callback_url]
	    
	    @paramList=paramList
        @checksum_hash=generate_checksum()
        
     #    paramList = Hash.new
	    # paramList["MID"] = "mobilo96691880612413"
	    # paramList["ORDER_ID"] = "#{Time.now.to_i.to_s}"
	    # paramList["CUST_ID"] = @api_current_user.id&.as_json["$oid"]
	    # paramList["INDUSTRY_TYPE_ID"] = "Retail"
	    # paramList["CHANNEL_ID"] = "WAP"
	    # paramList["TXN_AMOUNT"] = "1"
	    # paramList["MSISDN"] = "+919997217401"
	    # paramList["EMAIL"] = "gunjackaryan@gmail.com"
	    # paramList["WEBSITE"] = "wavedio.herkuapp.com"
	    # @paramList=paramList
     #    @checksum_hash=generate_checksum()
        render json: {responseCode: 200, responseMessage: "Checksum generated successfully.",checksum_hash: @checksum_hash}
    end 





	#.billings.where({'created_at' => {'$gt' => Date.today-7.days}})
  
	
end
