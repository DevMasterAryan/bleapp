class Admin::DashboardController < ApplicationController
  layout 'admin_lte_2'
  before_action :authenticate_admin_user
  def home
    # @admin_user = AdminUser.where(id: session[:user_id]["$oid"]).first

  end



end
