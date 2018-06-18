class Api::V1::DevicesController < ApplicationController
	skip_before_action :verify_authenticity_token,only: [:search_device]
	before_action :authenticate,only: [:search_device]
	
	def search_device
		@device = Device.find_by(qr_code: params[:qr_code])
		if @device.present?
			@device_detail = {id: @device&.id&.as_json["$oid"] || "", bt_id: @device&.bluetooth_id || "", stolen_status: @device&.stolen || false } 
			begin
				@session = Session.create(user_id: @api_current_user.id, device_id: @device.id, site_id: @device&.location.id)
			  	return render json: {responseCode: 200, device_detail: @device_detail}	
			rescue Exception => e
				return render json: {responseCode: 500, device_detail: e}	
			end
		else
			return render json: {responseCode: 500, responseMessage: "Device not found."}
		end
	end
end
