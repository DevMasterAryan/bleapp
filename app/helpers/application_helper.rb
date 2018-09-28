module ApplicationHelper
  
  def current_user
  	begin
      #@current_user ||= AdminUser.where(id: session[:user_id]["$oid"])&.first
  		@current_user ||= AdminUser.find(cookies.signed[:user_id])
  	rescue Exception => e
  	  nil	
  	end
  end

  def logged_in?
    !current_user.nil?
  end	


   def super_admin_user?
    return true if current_user.category.name=="SuperAdmin"
   end 

   def category_tabs
     return current_user.category.tabs if current_user.category.tabs.present?
   end
  

end
