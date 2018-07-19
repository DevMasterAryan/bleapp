class Admin::PasswordResetsController < ApplicationController
   def reset_password
   	binding.pry
   	
   end
   
   def create_reset_password
   	
   end

   def send_reset_password
     user  = AdminUser.where(email: params[:user][:email]).first
   	 user.update(reset_token: Digest::SHA256.hexdigest(Time.now.to_s))
   	 user.update(reset_created_at: DateTime.now)
     AdminMailer.reset_password(user).deliver_now!
     

   end

   
end
