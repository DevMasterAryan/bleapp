class Api::V1::DevicesController < ApplicationController
	skip_before_action :verify_authenticity_token,only: [:search_device,:device_locations,:stolen_device_location_update,:device_location_search]
	before_action :authenticate,only: [:search_device,:device_locations,:stolen_device_location_update,:device_location_search]
	
	def search_device
		@device = Device.any_of({mac_address: params[:qr_code]},{device: params[:qr_code]}).first
		# @device = Device.find_by(device: params[:qr_code]) || Device.find_by(mac_address: params[:qr_code])
		if @device.present?
			@device_detail = {id: @device&.id&.as_json["$oid"] || "", bt_id: @device&.bluetooth_id || "", stolen_status: @device&.stolen || false, identifier: @device&.identifier || "", mac_address: @device&.mac_address || "", device_status: @device&.device_status, site_display_name: @device&.site_display_name, site_name: @device&.site_display_name? ? @device&.site_name : "" } 
			begin
				@session = Session.create(user_id: @api_current_user.id, device_id: @device.id, site_id: @device&.location.id)
			  	return render json: {responseCode: 200, device_detail: @device_detail, session_id: @session&.id&.as_json["$oid"] || ""}	
			rescue Exception => e
				return render json: {responseCode: 500, device_detail: e}	
			end
		else
			return render json: {responseCode: 500, responseMessage: "Device not found."}
		end
	end

	def device_locations
		#search params,lat ,long 
		if params[:search].present?
          @devices = Device.where({site_name: /^params[:search]/i})
        elsif params[:lat].present? && params[:long].present?
          @devices = Device.all	
        else
		 @devices = Device.all 
		end
		
		
		if @devices.present?
			site_names = []
			@devices.each do |device|
				site_names << {name: device&.site_name, lat: device&.location&.lat, long: device&.location&.long} 
			end
			return render json: {responseCode: 200, location: site_names}
		else
			return render json: {responseCode: 200, responseMessage: "No location found.", location: []}
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
			# results = Geocoder.search(params["location"])
			# @coordinates = results.first.coordinates
			# @device.location.update(name: params["location"],lat: @coordinates[0], long: @coordinates[1])
			  @device.location.update(lat: params["lat"], long: params["long"])
			  results = Geocoder.search([params["lat"], params["long"]])
			  @api_current_user.update(lat: params["lat"], long: params["long"], location: results.first.address)
			rescue Exception => e
				return render json: {responseCode: 500, responseMessage: "Something went wrong."}
			end
			return render json: {responseCode: 200, responseMessage: "Location updated successfully."}
		else
			return render json: {responseCode: 200, responseMessage: "Device not found."}
		end
	end

	def device_status
     @device = Device.find_by(id: params["device_id"])
     @session = Session.find_by(id: params["session_id"])
     if @device.present?
       @session = @session.update(device_battery_start: params["device_status"])
       # @device.update(device_status: params["device_status"])
       @device_detail = {id: @device&.id&.as_json["$oid"] || "", bt_id: @device&.bluetooth_id || "", stolen_status: @device&.stolen || false, identifier: @device&.identifier || "", mac_address: @device&.mac_address || "", device_status: @session&.device_battery_start,site_display_name: @device&.site_display_name, site_name: @device&.site_display_name? ? @device&.site_name : ""  } 
       return render json: { responseCode: 200, responseMessage: "Device status saved successfully.",device_detail: @device_detail }
     else
     	return render json: {responseCode: 500, responseMessage: "Device not found."}
     end		
	end
end
