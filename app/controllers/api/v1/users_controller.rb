class Api::V1::UsersController < ApplicationController
	skip_before_action :verify_authenticity_token,only: [:apply_credit,:charge_history,:user_last_charge, :checksum,:billing_not_rated, :charging_status, :checksum_add_money,:add_money_transaction_status]
	before_action :authenticate,only: [:apply_credit,:charge_history,:user_last_charge,:billing_not_rated, :checksum,:billing_not_rated, :charging_status,:checksum_add_money,:add_money_transaction_status]
    # include PaytmHelper
   require './lib/encryption_new_pg.rb'
  include EncryptionNewPG
  extend PaytmHelper

	def apply_credit

		@package  = Package.find_by(id: params["package_id"])
		@session = Session.find_by(id: params["session_id"])


        #promotion applied
        #@package&.package_time.minutes
        if params["mop"]=="promotion"
          return render json: {responseCode: 200, responseMessage: "You have not promotion to apply."}  if @api_current_user.promotion_count<1
          @billing = @api_current_user.billings.new(method_of_payment: "promotion",session_id: @session.id, package_id: @package.id,usage_start_ts: DateTime.current,usage_end_ts: DateTime.current + @package&.package_time.minutes, amount: @package&.package_value, device_id: @session.device.id).save(validate: false)
			# @billing.update(transaction_id: credit.to_s+@billing.id.as_json["$oid"])
         
          rm = @api_current_user.promotion_count - 1
          @api_current_user.update(promotion_count: rm)
          bid = @api_current_user.billings.last.id.as_json["$oid"] 
          Billing.session_destroy bid, @api_current_user.id.as_json["$oid"]
          @api_current_user.reload
          return render json: {responseCode: 200, responseMessage: "Your promotion applied.", remaining_credit: @api_current_user.credit,start_time: @api_current_user&.billings&.last&.usage_start_ts&.to_i || "",end_time: @api_current_user&.billings&.last&.usage_end_ts&.to_i || "",site_display_name: @api_current_user&.billings&.last&.session&.device&.site_display_name, site_name: @api_current_user&.billings&.last&.session&.device&.site_display_name? ? @api_current_user&.billings&.last&.session&.device&.site&.site_name : "", remaining_promotion: rm, billing_id: @api_current_user.billings.last.id.as_json["$oid"], remaining_time:  (@api_current_user&.billings&.last&.usage_end_ts.to_f - DateTime.current.to_f).to_i || 0, time_spend: (DateTime.current.to_f - @api_current_user&.billings&.last&.usage_start_ts.to_f).to_i || 0}
         	 
        end 
        #promotion applied code end
		# @session.update(device_battery_status: params["device_battery_status"])
		if params["mop"]=="credit"
		if !@api_current_user.credit.nil? and @api_current_user&.credit >= @package.package_value
			@remaining_credit = @api_current_user&.credit -  @package.package_final
			@api_current_user.update(credit: @remaining_credit)
			# @transaction = Transaction.create(transaction_id: "", status: true, amount: @package&.package_value)
			@billing = @api_current_user.billings.new(method_of_payment: "credit",session_id: @session.id, package_id: @package.id,
				usage_start_ts: DateTime.current,usage_end_ts: DateTime.current + @package&.package_time.minutes, amount: @package&.package_value, device_id: @session.device.id).save(validate: false)
            bid = @api_current_user.billings.last.id.as_json["$oid"]     
            Billing.session_destroy bid,@api_current_user.id.as_json["$oid"] 
			# @billing.update(transaction_id: @package.package_final.to_s+@api_current_user.billings.last.id.as_json["$oid"])
			return render json: {responseCode: 200, responseMessage: "Your credit applied.", remaining_credit: @remaining_credit,start_time: @api_current_user&.billings&.last&.usage_start_ts&.to_i || "", end_time: @api_current_user&.billings&.last&.usage_end_ts&.to_i || "",site_display_name: @api_current_user&.billings&.last&.session&.device&.site_display_name, site_name: @api_current_user&.billings&.last&.session&.device&.site_display_name? ? @api_current_user&.billings&.last&.session&.device&.site&.site_name : "", remaining_promotion: @api_current_user.promotion_count, billing_id: @api_current_user.billings.last.id.as_json["$oid"], remaining_time:  (@api_current_user&.billings&.last&.usage_end_ts.to_f - DateTime.current.to_f).to_i || 0, time_spend: (DateTime.current.to_f - @api_current_user&.billings&.last&.usage_start_ts.to_f).to_i || 0}
		else
			return render json: {responseCode: 500, responseMessage: "Your credit is not enough."}
		end
   elsif params["mop"] !=  "credit" || "promotion" 
          # txn_amount = params[:card]
          # response = User.paytm_withdraw_api(@api_current_user,"0.10")
        	 resp= Billing.transaction_status params
            if resp
              if params[:credit].present?
                   @remaining_credit = @api_current_user.credit - params[:credit].to_i 
                   @api_current_user.update(credit: @remaining_credit)
              end
        				@billing = @api_current_user.billings.new(method_of_payment: params["mop"],session_id: @api_current_user.sessions.last.id, package_id: @package.id,
        				usage_start_ts: DateTime.current,usage_end_ts: DateTime.current+@package&.package_time.minutes,transaction_id: params[:transaction_id],amount: params[:card].present? ? params[:card] : @package&.package_final, device_id: @session.device.id)
      				if @billing.save
      					bid = @api_current_user.billings.last.id.as_json["$oid"] 
      					Billing.session_destroy bid, @api_current_user.id.as_json["$oid"]
      					return render json: {responseCode: 200, responseMessage: "Payment done successfully.", remaining_credit: @api_current_user.credit,start_time: @api_current_user&.billings&.last&.usage_start_ts&.to_i || "", end_time: @api_current_user&.billings&.last&.usage_end_ts&.to_i || "",site_display_name: @api_current_user&.billings&.last&.session&.device&.site_display_name, site_name: @api_current_user&.billings&.last&.session&.device&.site_display_name? ? @api_current_user&.billings&.last&.session&.device&.site&.site_name : "", remaining_promotion: @api_current_user.promotion_count, billing_id: @api_current_user.billings.last.id.as_json["$oid"], remaining_time:  (@api_current_user&.billings&.last&.usage_end_ts.to_f - DateTime.current.to_f).to_i || 0, time_spend: (DateTime.current.to_f - @api_current_user&.billings&.last&.usage_start_ts.to_f).to_i || 0}
      				else
      					return render json: {responseCode: 500, responseMessage: "Unsuccessful transaction."}
      				end
            else
              return render json: {responseCode: 500, responseMessage: "Unsuccessful transaction."}
            end
			else
				return render json: {responseCode: 500, responseMessage: "Unsuccessful transaction."}
			end   	 
		# end		
	end

	def charge_history
		@billings = Billing&.where(user_id: @api_current_user).order(created_at: :desc).paginate(:page =>params[:page], :limit => params[:per_page]) 	
		if @billings.present?
		    @billings_data = []
		    @billings.each do |billing|
		    	# billing.created_at.strftime("%d/%m/%Y")+ " "+"at"+" "+billing.created_at.strftime("%I:%M %p")
		   		@billings_data << {location: billing&.session&.device&.site&.location_address || "",billing_ts:  billing.created_at.to_i || "",package_time: billing&.package&.package_time || "", active: DateTime.current > billing&.usage_end_ts ? false : true, rating: billing&.user_feedbacks&.where(rating_status: true)&.first&.rating.to_i || 0, billing_id: billing.id&.as_json["$oid"], package_value: billing.package.package_value,package_gst: billing.package.package_gst, package_final: billing.package.package_final, site_name: billing&.session&.device&.site&.site_name || "", start_time: billing&.usage_start_ts&.to_i, end_time: billing&.usage_end_ts&.to_i }
		    end
		    return render json: {responseCode: 200, charge_history: @billings_data,:pagination=>{page_no: params[:page],per_page: params[:per_page],max_page_size: @api_current_user.billings.count/params[:per_page].to_i+1, total_records: @api_current_user.billings.count}}
		else
			return render json: {responseCode: 200, responseMessage: "History not found.", charge_history: []}
		end
	end

	def user_last_charge
		# @additional_topic = StaticContent.where("additional"=> true)
        
		@last_charge = @api_current_user&.billings&.last

		if @last_charge.present?
			# @last_charge.created_at.strftime("%d/%m/%Y")+ " "+"at"+" "+@last_charge.created_at.strftime("%I:%M %p")
			return render json: {responseCode: 200, last_charge: {location: @last_charge&.session&.device&.site&.location_address || "",billing_ts:  @last_charge.created_at.to_i || "",package_time: @last_charge&.package&.package_time || "", active: DateTime.current > @last_charge&.usage_end_ts ? false : true, rating: @last_charge.user_feedbacks&.where(rating_status: true)&.first&.rating&.to_i || 0, billing_id: @last_charge.id&.as_json["$oid"], package_value: @last_charge.package.package_value,package_gst: @last_charge.package.package_gst, package_final: @last_charge.package.package_final, site_name: @last_charge&.session&.device&.site&.site_name || "", start_time: @last_charge&.usage_start_ts&.to_i, end_time: @last_charge&.usage_end_ts&.to_i }}
		else
			return render json: {responseCode: 200, responseMessage: "No charge found."}
		end		

	end
    
    def billing_not_rated
    if params[:rating_status].present? && params[:billing_id].present?
    	@billing = Billing.find_by(id: params[:billing_id])
    	@billing.user_feedbacks.create(rating_status: params[:rating_status], user_id: @api_current_user.id)
       return render json: {responseCode: 200, responseMessage: "Status updated successfully."}
    else
       #first senario 
       # @billings = @api_current_user.billings.where({'created_at' => {'$gt' => Date.today-7.days}, 'rating'=> {'$lt'=> 1},'usage_end_ts'=> {'$lt'=> DateTime.current}, 'rating_status'=> false}).limit(3).map { |r| [billing_id: r.id.as_json["$oid"], site_name: r&.session&.device&.site&.site_name] }.flatten!
       # billing_rated = @api_current_user.user_feedbacks.map{|r| r.billing_id}
       #second senario
       # billing_rated = @api_current_user.user_feedbacks.map{|r| r.billing_id}
       # @billings = (@api_current_user.billings.where({'created_at' => {'$gt' => Date.today-7.days}, 'usage_end_ts'=> {'$lt'=> DateTime.current}}) - Billing.in(id: billing_rated) ).first(3).map{|r| [billing_id: r.id.as_json["$oid"], site_name: r&.session&.device&.site&.site_name]}.flatten! 
 
 
      #hit the flow
      # last_billing = @api_current_user.billings.where({'usage_end_ts'=> {'$lt'=> DateTime.current}}).order(created_at: :desc).first
       
       last_billing = @api_current_user.billings.where({'usage_end_ts'=> {'$lt'=> DateTime.current}}).order(created_at: :desc).first

      check_rated = @api_current_user.user_feedbacks.where(billing_id: last_billing.id, rating_status: true) if last_billing.present? 
      if check_rated.present?
         return render json: {responseCode: 200,responseMessage: "No billing found.", billing: [], promotion: @api_current_user.promotion_count, credit: @api_current_user.credit} 
      else
      	if last_billing.present?
          return render json: {responseCode: 200, responseMessage: "Billing fetched successfully.", billing: [billing_id: last_billing.id.as_json["$oid"], site_name: last_billing&.session&.device&.site&.site_name], promotion: @api_current_user.promotion_count, credit: @api_current_user.credit} 
        else
          return render json: {responseCode: 200,responseMessage: "No billing found.", billing: [], promotion: @api_current_user.promotion_count, credit: @api_current_user.credit} 	
      	end
      end        
         
      
      # if @billings.present? 
      #    return render json: {responseCode: 200, responseMessage: "Billing fetched successfully.", billing: @billings, promotions: @api_current_user.promotions.pluck(:promotion_count).sum} 
      # else
      #    return render json: {responseCode: 200, responseMessage: "No billing found.", billing: []} 
      # end 
    end


    end
   
    def checksum  
        #paramList = Hash.new
	    # paramList["CALLBACK_URL"]  = params[:callback_url]
	    # paramList["CHANNEL_ID"] = "WAP"
	    # paramList["CUST_ID"] = @api_current_user.id&.as_json["$oid"]
	    # paramList["EMAIL"] = params[:email]
	    # paramList["INDUSTRY_TYPE_ID"] = "Retail"
	    # paramList["MID"] = "Wavedi27436137685521"
	    # paramList["MOBILE_NO"] = params[:mobile_no]
	    # paramList["ORDER_ID"] = params[:order_id]
	    # paramList["REQUEST_TYPE"] = "DEFAULT"
	    # paramList["TXN_AMOUNT"] = params[:txn_amount]
	    # paramList["WEBSITE"] = "APPSTAGING"
	    # @paramList=paramList

	    paramList = Hash.new
	    paramList["CALLBACK_URL"]  = params[:callback_url]
	    paramList["CHANNEL_ID"] = "WAP"
	    paramList["CUST_ID"] = @api_current_user.id&.as_json["$oid"]
	    # paramList["EMAIL"] = params[:email]
	    paramList["INDUSTRY_TYPE_ID"] = "Retail109"
	    paramList["MID"] = "Wavedi71402481589558"
	    # paramList["MOBILE_NO"] = params[:mobile_no]
	    paramList["ORDER_ID"] = params[:order_id]
	    # paramList["REQUEST_TYPE"] = "DEFAULT"
	    paramList["TXN_AMOUNT"] = params[:txn_amount]
	    paramList["WEBSITE"] = "APPPROD"

      paramList["PAYMENT_MODE_ONLY"] = params[:payment_mode_only]
      paramList["AUTH_MODE"] = params[:auth_mode]
      paramList["PAYMENT_TYPE_ID"] = params[:payment_type_id]
	    @paramList=paramList
        @checksum=new_pg_checksum(@paramList,"MUBUL!hKGtxvcmXM")
        render json: {responseCode: 200, responseMessage: "Checksum generated successfully.",checksum_hash: @checksum}
    end 


    def checksum_add_money
      paramList = Hash.new
      paramList["CALLBACK_URL"]  = params[:callback_url]
      paramList["CHANNEL_ID"] = "WAP"
      paramList["CUST_ID"] = @api_current_user.id&.as_json["$oid"]
      paramList["REQUEST_TYPE"] = "ADD_MONEY" 
      paramList["INDUSTRY_TYPE_ID"] = "Retail109"
      paramList["MID"] = "Wavedi71402481589558"
      paramList["ORDER_ID"] = params[:order_id]
      # paramList["REQUEST_TYPE"] = "DEFAULT"
      paramList["TXN_AMOUNT"] = params[:txn_amount]
      paramList["WEBSITE"] = "APPPROD"
      paramList["SSO_TOKEN"] = @api_current_user.paytm_access_token
      @paramList=paramList
        @checksum_hash=new_pg_checksum(@paramList,"MUBUL!hKGtxvcmXM") 
      # signature = User.checksum(@api_current_user,params["txn_amount"],"ADD_MONEY")
        render json: {responseCode: 200, responseMessage: "Checksum generated successfully.",checksum_hash: @checksum_hash}
      
    end


    def charging_status
      billing  = Billing.find_by(id: params[:billing_id])	
      if billing.present?
      
        billing.update(charging_status: params[:charging_status])
        #charging_status changed from boolean to string
        #unless params[:charging_status].present?
        if params[:charging_status]=="00"
          if billing.method_of_payment == "promotion"
            @api_current_user.update(promotion_count: @api_current_user.promotion_count + 1)
          else
            @api_current_user.update(credit: billing.package.package_final) 
          end
          billing.update(usage_end_ts: billing.usage_start_ts)  
          return render json: {responseCode: 200, responseMessage: "Sorry! Due to some technical reasons, your charge could not start. Your amount will be credited back.", promotion: @api_current_user.promotion_count, credit: @api_current_user.credit}
        end
        
      else
        return render json: {responseMessage: 500, responseMessage: "Try again later."}
      end
    end


    def add_money_transaction_status
      resp= Billing.transaction_status params
      if resp
        return render json: {responseCode: 200, responseMessage: "Add Money Transaction verified successfully."}
      else
        return render json: {responseCode: 500, responseMessage: "Add Money Transaction verification failed."}
      end

    end
end
