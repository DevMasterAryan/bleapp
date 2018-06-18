class Api::V1::StaticContentsController < ApplicationController
	skip_before_action :verify_authenticity_token,only: [:static_contents]
	before_action :authenticate,only: [:static_contents]
	
	def static_contents
		if params[:type].present?
			begin
				@result = StaticContent.where(title: params[:type])&.first
				@static_content = {title: @result&.title, content:  @result.content}
				return render json: {responseCode:200, static_content: @static_content}				
			rescue Exception => e
				return render json: {responseCode:500, responseMessage: e}	
			end
		end		 	 				
	end
end
