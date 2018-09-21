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

  def send_credential 
    temp_password = SecureRandom.hex(7)
    AdminUser.find_by(id: params[:admin_user_id]).update(category_id: params[:categories], is_active?: true, password: temp_password, password_confirmation: temp_password)
    user_id = params[:admin_user_id]
    UserMailer.send_login_credential(user_id, temp_password).deliver_now!
    redirect_to admin_admin_users_path, notice: "Send Successfully"
  end

  def suspend_user
    AdminUser.find_by(id: params[:id]).update(is_active?: false)
    redirect_to admin_admin_users_path, alert: "Suspended"
  end

  def import
  	AdminUser.import(params[:file])
  	redirect_to admin_admin_users_path, notice: "Users imported"  	
  end

end
