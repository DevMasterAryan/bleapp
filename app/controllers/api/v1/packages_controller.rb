class Api::V1::PackagesController < ApplicationController
	skip_before_action :verify_authenticity_token,only: [:packages_listing]
	before_action :authenticate,only: [:packages_listing]

	def packages_list
		@packages = Package.all
		if @packages.present?
			@packages_list = []
			@packages.each do |package| 
				@packages_list << {package_id:  package&.id&.as_json["$oid"] || "", package_time: package&.package_time || "", package_value: package.package_value}
			end
			return render json: {responseCode: 200, package_list: @packages_list}
		else
			return render json: {responseCode: 500, reponseMessage: "No packages found."}
		end
		
	end
end
