module ApplicationHelper
  
  def current_user
  	begin
      @current_user ||= AdminUser.where(id: session[:user_id]["$oid"])&.first
  		
  	rescue Exception => e
  	  nil	
  	end
  end

  def logged_in?
    !current_user.nil?
  end	
  
  

end
