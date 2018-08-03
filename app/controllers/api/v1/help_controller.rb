class Api::V1::HelpController < ApplicationController
    before_action :authenticate
    skip_before_action :verify_authenticity_token
	def get_b1_b2_list
	  @helps = Help.where(status: "Active")
      return render json: {responseCode: 200, responseMessage: "List fetched successfully.", list: @helps}	   
	end
    
    def submit_b1_b2
      @billing = @api_current_user.billings.find_by(id: params[:billing_id])
      # @api_current_user.user_responses.new(help_id: params[:help_id], feedback: params[:feedback], billing_id: params[:billing_id])
      @billing.update_attributes(feedback: params[:feedback], help_id: params[:help_id], rating: params[:rating], rating_status: params[:rating_status])      
      if @api_current_user.save
         render json: {responseCode: 200, responseMessage: "Submitted successfully."}   
      else
      	render json: {responseCode: 500, responseMessage: "Try again later."}   
      end	
    end

    def feedback_and_faq_list
       # @helps = Help.where(status: {'$in': ["Feedback", "FAQ"]})
       @feedback = Help.where(status: "Feedback")
       @faq = Help.where(status: "FAQ")
       render json: {responseCode: 200,responseMessage: "List fetched successfully.",feedback: @feedback, faq: @faq}
    end
    

    def r1_r2_list
      @rating_list = Help.where(status: "Rating")
      render json: {responseCode: 200, responseMessage: "List fetched successfully.", rating: @rating_list}
    end
   
    def submit_feedback_api
      billing = Billing.where(id: params[:billing_id]).first
      @user_feedback = UserFeedback.new(user_id: @api_current_user.id, site_id: params[:site_id], help_id: params[:help_id], billing_id: params[:billing_id], session_id: billing.present? ? billing.session.id : "")
      if @user_feedback.save
          render json: {responseCode: 200, responseMessage: "Submitted successfully."}
      else
        render json: {responseCode: 500, responseMessage: "Try again later."}
      end 
    end




end
