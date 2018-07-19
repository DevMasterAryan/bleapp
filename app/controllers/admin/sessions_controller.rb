class Admin::SessionsController < ApplicationController
 layout :false, only: [:login, :forgot_password]
 before_action :authenticate_admin_user, only: [:destroy] 
  def login
   if current_user
      redirect_to admin_dashboard_home_path
   end
  end
  
  def create
    user = AdminUser.where(email: params[:admin_user][:email].downcase).first
    if user && user.authenticate(params[:admin_user][:password])
      log_in(user)
      remember_me(user) if params[:remember_me].present?
      flash[:notice] = "Login successfully."
      redirect_to admin_dashboard_home_path
      # Log the user in and redirect to the user's show page.
    else
      # Create an error message.
       flash[:alert] = 'Invalid email/password combination'
       redirect_to admin_sessions_login_path
    end  	 
  end


  def destroy
    log_out
    flash[:notice] = "Logout successfully."
    redirect_to admin_sessions_login_url
  end
  
  def forgot_password
    
  end
  



end
