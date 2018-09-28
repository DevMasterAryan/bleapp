class Admin::DashboardController < ApplicationController
  layout 'admin_lte_2'
  before_action :authenticate_admin_user
  def home
     if params[:tab_id].present?
        @tab  = Tab.find_by(id: params[:tab_id])
        @tab_type = @tab.type
        p "#{@tab_type}"
       
     end
  end



end
