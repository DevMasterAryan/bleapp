class Admin::PasswordResetsController < ApplicationController
   before_action :get_user,   only: [:reset_password, :update]
   layout :false
   def reset_password
   	 # @user = AdminUser.where(email: params[:email], reset_token: params[:format]).first
      begin
      unless @user.present? or @user.reset_token==params[:format] or @user.reset_created_at > DateTime.curent-2.hours
        flash[:alert] = "Link expired."
        redirect_to admin_sessions_login_path
      end
        
      rescue Exception => e
        flash[:alert] = "Link expired."
        redirect_to admin_sessions_login_path
      end
   end
   
   def update
   	 if @user.update(password: params[:admin_user][:password])
        flash[:notice] = "Password updated successfully."
        redirect_to admin_sessions_login_path
     else 
       flash[:alert] = "Fail to update password, try again later"
       redirect_to admin_sessions_login_path
     end
   end

   def send_reset_password
     user  = AdminUser.where(email: params[:admin_user][:email]).first
   	 user.update(reset_token: Digest::SHA256.hexdigest(Time.now.to_s))
   	 user.update(reset_created_at: DateTime.now)
     UserMailer.reset_password(user).deliver_now!
      
     
     flash[:notice] = "Reset password link successfully send to your email id." 
     redirect_to admin_sessions_login_path
     
   end


   private
   def get_user
    @user = AdminUser.where(email: params[:email], reset_token: params[:format]).first
    unless (@user)
      redirect_to admin_sessions_login_path
    end
  end

   
end
