class Api::V1::TransactionsController < ApplicationController
	skip_before_action :verify_authenticity_token,only: [:package_payment,:send_paytm_otp,:validate_paytm_otp,:check_paytm_balance,:validate_paytm_access_token]
	before_action :authenticate,only: [:package_payment,:send_paytm_otp,:validate_paytm_otp,:check_paytm_balance,:validate_paytm_access_token]
	require 'net/http' 
	require 'uri'



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


	def validate_token
		 
		 # response.code 
		 # response.body
	end

	def send_paytm_otp
		begin			
			uri = URI.parse("https://accounts.paytm.com/signin/otp")
			request = Net::HTTP::Post.new(uri)
			request.content_type = "application/json"
			request["Cache-Control"] = "no-cache"
			request.body = JSON.dump({
			  "email" => params["email"],
			  "phone" => params["mobile"],
			  "clientId" => "merchant-wavedio",
			  "scope" => "wallet",
			  "responseType" => "token"
			})
			req_options = {
			  use_ssl: uri.scheme == "https",
			}
			response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
			  http.request(request)
			end
			response = JSON.parse(response.body)
			if response["status"] == "SUCCESS"
				return render json: {responseCode: 200, responseMessage: response["message"],state: response["state"]}
			else
				return render json: {responseCode: 500, responseMessage: response["message"]}
			end
		rescue Exception => e
			return render json: {responseCode: 500, responseMessage: e.message}
		end
	end

	def validate_paytm_otp
		begin
			uri = URI.parse("https://accounts.paytm.com/signin/validate/otp")
			request = Net::HTTP::Post.new(uri)
			request.content_type = "application/json"
			request["Authorization"] = "basic bWVyY2hhbnQtd2F2ZWRpbzpsbXJhaTF6cE9hT1JTbXdCdGVMdHhKYnRFRDh5\nUDVvZw=="
			request["Cache-Control"] = "no-cache"
			request.body = JSON.dump({
			  "otp" => params["otp"],
			  "state" => params["state"]
			})
			req_options = {
			  use_ssl: uri.scheme == "https",
			}
			response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
			  http.request(request)
			end
			response = JSON.parse(response.body)
		if response["access_token"].present?
			@api_current_user.update(paytm_access_token: response["access_token"], paytm_access_token_exp_date: Time.at(response["expires"].to_i))
			return render json: {responseCode: 200, responseMessage: "OTP validated successfully.",paytm_access_token: response["access_token"]}
		else
			return render json: {responseCode: 500, responseMessage: response["message"]}
		end
			
		rescue Exception => e
			return render json: {responseCode: 500, responseMessage: e.message}
		end		
	end


	def validate_paytm_access_token
		begin
			uri = URI.parse("https://accounts.paytm.com/user/details") 
			request = Net::HTTP::Get.new(uri) 
			request["Cache-Control"] = "no-cache" 
			request["Session_token"] = @api_current_user.paytm_access_token 
			req_options = { use_ssl: uri.scheme == "https", } 
			response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http| 
				http.request(request) 
			end 
			response = JSON.parse(response.body)
			if response["id"].present?
				return render json: {responseCode: 200, responseMessage: "AccessToken validated successfully."}
			else
				return render json: {responseCode: 500, responseMessage: response["message"]}
			end
		rescue Exception => e
			return render json: {responseCode: 500, responseMessage: e.message}
		end
		
	end

	def check_paytm_balance
		begin
			uri = URI.parse("https://securegw.paytm.in/paymentservices/pay/consult")
			request = Net::HTTP::Post.new(uri)
			request.content_type = "application/json"
			request["Authorization"] = "basic bWVyY2hhbnQtd2F2ZWRpbzpsbXJhaTF6cE9hT1JTbXdCdGVMdHhKYnRFRDh5\nUDVvZw=="
			request["Cache-Control"] = "no-cache"
			request.body = JSON.dump({
			  "head" => {
			    "clientId" => "merchant-wavedio",
			    "requestTimestamp" => DateTime.now.to_i.to_s,
			    "signature" => User.checksum(@api_current_user,"ORDER120987","1"),
			    "version" => "v1",
			    "channelId" => "WAP"
			  },
			  "body" => {
			    "userToken" => "bfcdbeb8-16ee-4c18-9bc4-cdf19cbc6900",
			    "totalAmount" => "1",
			    "mid" => "Wavedi71402481589558",
			    "amountDetails" => {
			      "others" => "400.0",
			      "food" => "100.0"
			    }
			  }
			})

			req_options = {
			  use_ssl: uri.scheme == "https",
			}

			response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
			  http.request(request)
			end
			response = JSON.parse(response.body)
			if response["TxnId"].present?

			else
			end
		rescue Exception => e
			
		end	
	end

	def paytm_withdraw_api
		begin
			uri = URI.parse("https://securegw-stage.paytm.in/paymentservices/HANDLER_FF/withdrawScw")
			request = Net::HTTP::Post.new(uri)
			request.content_type = "application/json"
			request["Cache-Control"] = "no-cache"
			json_data = JSON.dump(
        {
          "MID" => "adadds",
          "ReqType" => "WITHDRAW",
          "TxnAmount" => "500",
          "AppIP" => "127.0.0.1",
          "OrderId" => "ORDER120987",
          "Currency" => "INR",
          "DeviceId" => "306623b4-xxxx-xxxx-b981-2823bc6400",
          "SSOToken" => "306623b4-xxxx-xxxx-b981-2823bc6400",
          "PaymentMode" => "PPI",
          "CustId" => "1040",
          "IndustryType" => "Retail",
          "Channel" => "WEB",
          "AuthMode" => "USRPWD",
          "CheckSum" => "Md9t9j1cRuC0DpcNq9m8onL06rWGzgr7VcoCGeK8+iSd1Y8tU712hNMyE1FoFYvxS0ia3+zvMtIqAZ8GcUROst18RiqFCHvz/WGMvlNVE3w="
          })
			request.body = "JsonData=#{json_data}"

			req_options = {
			  use_ssl: uri.scheme == "https",
			}

			response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
			  http.request(request)
			end



# response.code
# response.body



			
		rescue Exception => e
			
		end
		
	end

end
