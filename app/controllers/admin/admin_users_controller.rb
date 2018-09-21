class Admin::AdminUsersController < ApplicationController
  layout 'admin_lte_2'
  before_action :authenticate_admin_user
  
  def index
    # @admin_user = AdminUser.where(id: session[:user_id]["$oid"]).first
    if params[:search].present?
    @search = AdminUser.any_of({first_name: Regexp.new(".*#{params[:search]}.*","i")},{email: Regexp.new(".*#{params[:search]}.*","i")})
    @admin_users = @search.order("created_at desc")
    else
     @admin_users = AdminUser.all.order("created_at desc")
    end
  end

  def create_category 
    p  Category.find_by(id: params[:categories]).name
    p  AdminUser.find_by(id: params[:admin_user_id]).email
    binding.pry
     AdminUser.find_by(id: params[:admin_user_id]).update(category_id: params[:categories])
    redirect_to admin_admin_users_path, notice: "Change Successfully"
  end

  def import
  	AdminUser.import(params[:file])
  	redirect_to admin_admin_users_path, notice: "Users imported"  	
  end

end
