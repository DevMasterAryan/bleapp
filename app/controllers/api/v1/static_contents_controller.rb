class Api::V1::StaticContentsController < ApplicationController
	skip_before_action :verify_authenticity_token,only: [:static_contents,:faqs]
	before_action :authenticate,only: [:static_contents,:faqs]
	
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

	def faqs
		@faqs = Faq.all.to_a
		if @faqs.present?
			faqs = []
			@faqs.each do |f|
				faqs << {question: f&.question || "", answer: f&.answer || ""}
			end
			return render json: {responseCode: 200, faqs: faqs}
		else
			return render json: {responseCode: 200, responseMessage: "No faqs found."}
		end
		
	end
end
