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

  def set_tab_value
  	x = {"tab_values": params[:tab_value].as_json}
  	key = params[:tab_value].as_json.keys.first
  	value = params[:tab_value].as_json.values[0]
  	Tab.find_by(id: params[:id]).value[:tab_values].delete(key) if Tab.find_by(id: params[:id]).value[:tab_values].keys.include?(key)
  	# value = Tab.find_by(id: params[:id]).value.merge(x)
  	abc = Tab.find_by(id: params[:id]).value
  	abc[:tab_values][:"#{key}"] = value
  	Tab.find_by(id: params[:id]).update(value: abc)
  	redirect_to request.referer
  end

  def get_tab_value
  	binding.pry
  end



end
