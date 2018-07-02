class Api::V1::StaticContentsController < ApplicationController
	skip_before_action :verify_authenticity_token,only: [:static_contents,:faqs,:additional_topic,:query]
	before_action :authenticate,only: [:static_contents,:faqs,:additional_topic,:query]
	
	def static_contents
		if params[:type].present?
			begin
				@result = StaticContent.where(title: params[:type])&.first
				@static_content = {title: @result&.title, content:  @result&.content}
				return render json: {responseCode:200, static_content: @static_content}				
			rescue Exception => e
				return render json: {responseCode:500, responseMessage: e}	
			end
		end		 	 				
	end

	def additional_topic
		@additional_topic = StaticContent.where("additional"=> true)
		if @additional_topic.present?
			additional_topic = []
			@additional_topic.each do |at|
				additional_topic << {id: at&.id&.as_json["$oid"] || "", title: at&.title, content:  at&.content}
			end
			return render json: {responseCode:200, additional_topics: additional_topic}
		else
			return render json: {responseCode:500, responseMessage: "No additional topic found."}
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

	def query
	  # UserMailer.contact_us(params[:message]).deliver_now
      @help = @api_current_user.helps.new(content: params[:message], status: "Pending" )
      if @help.save
        render json: {responseCode: 200, responseMessage: "Message send successfully."}
      else
      	render json: {responseCode: 500, responseMessage: "Something went wrong, try again later."}
      end
    end
end
