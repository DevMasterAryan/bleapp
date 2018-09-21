class Admin::AdminUsersController < ApplicationController
  layout 'admin_lte_2'
  before_action :authenticate_admin_user
  
  def index
    # @admin_user = AdminUser.where(id: session[:user_id]["$oid"]).first
    @search = AdminUser.any_of({first_name: Regexp.new(".*#{params[:search]}.*","i")},{email: Regexp.new(".*#{params[:search]}.*","i")}).where(role: "user")
    @admin_users = @search.order("created_at desc")
    # @admin_users = AdminUser.all.order("created_at desc")
  end

  def import
  	AdminUser.import(params[:file])
  	redirect_to admin_admin_users_path, notice: "Users imported"  	
  end

end
