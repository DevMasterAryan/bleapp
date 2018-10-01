class Admin::DashboardController < ApplicationController
  layout 'admin_lte_2'
  before_action :authenticate_admin_user
  def home
     if params[:tab_id].present?
        @tab  = Tab.find_by(id: params[:tab_id])
        @show_tabs = @tab.columns.keys 
        @show = @tab.columns
        @tab_type = @tab.type
        p "#{@tab_type}"
        @table_name = @tab.columns.keys.first
        @model_name  = @tab.columns.keys.first.camelize.constantize
        
        @model_object = @model_name.new
        
        @table_field_keys = @tab.columns[@table_name].keys
     
     end
  end


end
