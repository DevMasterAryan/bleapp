class Api::V1::PaymentMethodsController < ApplicationController
 before_action :authenticate
 skip_before_action :verify_authenticity_token

 def list 
  	render json: {responseCode: 200, reponseMessage: "Payment method list fetched successfully.", payment_methods_list: (PaymentMethod.pluck(:name)-(@api_current_user&.user_payment_method&.method || [])), added_payment_methods: (@api_current_user&.user_payment_method&.method || [])}
 end 
 
 def add
   payment_methods = []
   if @api_current_user.user_payment_method.nil? 	
   	 payment_methods << params[:payment_method]
     @api_current_user.user_payment_method  = UserPaymentMethod.new(method: payment_methods)   
     return render json: {responseCode: 200, reponseMessage: "Payment method added successfully.", added_methods: @api_current_user.user_payment_method.method}
   
   else
     payment_methods =  @api_current_user.user_payment_method.method
     payment_methods << params[:payment_method]
     @api_current_user.user_payment_method  = UserPaymentMethod.new(method: payment_methods)  
     return render json: {responseCode: 200, reponseMessage: "Payment method added successfully.", added_methods: @api_current_user.user_payment_method.method}  
   end
   

 end 
 

 def remove
  # binding.pry
   methods = @api_current_user.user_payment_method.method
   methods.delete(params[:payment_method])
   @api_current_user.user_payment_method.update(method: methods)
   render json: {responseCode: 200, reponseMessage: "Method remove successfully.", payment_methods: @api_current_user.user_payment_method.method}
 end 
 
end
