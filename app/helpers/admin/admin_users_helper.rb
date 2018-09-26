module Admin::AdminUsersHelper
  def get_categories
  	@categories = Category.where(:id.nin=> Category.where(name: "SuperAdmin").pluck(:id))
  end

  def send_login_credential user_id
  	
  end
end
