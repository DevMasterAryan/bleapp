module Admin::AdminUsersHelper
  def get_categories
  	@categories = Category.all
  end

  def send_login_credential user_id
  	
  end
end
