class Api::V1::DevicesController < ApplicationController
	skip_before_action :verify_authenticity_token,only: [:search_device,:device_locations,:stolen_device_location_update,:device_location_search]
	before_action :authenticate,only: [:search_device,:device_locations,:stolen_device_location_update,:device_location_search]
	
	def search_device
		@device = Device.find_by(qr_code: params[:qr_code])
		if @device.present?
			@device_detail = {id: @device&.id&.as_json["$oid"] || "", bt_id: @device&.bluetooth_id || "", stolen_status: @device&.stolen || false, identifier: @device&.identifier || "", mac_address: @device&.mac_address || "" } 
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

	def device_locations
		@locations = Location.all
		if @locations.present?
			locations = []
			@locations.each do |location|
				locations << {name: location&.name, lat: location&.lat, long: location&.long} 
			end
			return render json: {responseCode: 200, location: locations}
		else
			return render json: {responseCode: 500, responseMessage: "No location found."}
		end		
	end

	def device_location_search
		@location = Location.find_by(:name=>  params["location"])
		if @location.present?
			return render json: {responseCode: 200, location_name: @location.name, lat: @location.lat, long: @location.long }
		else
			return render json: {responseCode: 500, responseMessage: "Location not found."}
		end
		
	end

	def stolen_device_location_update
		@device = Device.find_by(id: params["device_id"])
		if @device.present?
			begin				
			results = Geocoder.search(params["location"])
			@coordinates = results.first.coordinates
			@device.location.update(name: params["location"],lat: @coordinates[0], long: @coordinates[1])
			rescue Exception => e
				return render json: {responseCode: 500, responseMessage: "Something went wrong."}
			end
			return render json: {responseCode: 200, responseMessage: "Location updated successfully."}
		else
			return render json: {responseCode: 200, responseMessage: "Device not found."}
		end
	end
end
