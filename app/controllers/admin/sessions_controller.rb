class Admin::SessionsController < ApplicationController
 layout :false, only: [:login]

  def login
   
  end
  
  def create
    user = AdminUser.where(email: params[:admin_user][:email].downcase).first
    if user && user.authenticate(params[:admin_user][:password])
      flash[:notice] = "Login successfully."
      redirect_to admin_sessions_login_path
      # Log the user in and redirect to the user's show page.
    else
      # Create an error message.
       flash[:alert] = 'Invalid email/password combination'
      redirect_to admin_sessions_login_path
    end  	 
  end


end
