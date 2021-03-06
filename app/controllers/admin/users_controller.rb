class Admin::UsersController < ApplicationController
  layout 'admin_lte_2'
  before_action :authenticate_admin_user
  
  def index
    # @admin_user = AdminUser.where(id: session[:user_id]["$oid"]).first
    @users = AdminUser.all.order("created_at desc")
  end

  def import
  	AdminUser.import(params[:file])
  	redirect_to admin_users_path, notice: "Users imported"  	
  end

end
