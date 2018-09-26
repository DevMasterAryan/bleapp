require 'will_paginate/array'

class Admin::TabsController < ApplicationController
  layout 'admin_lte_2'
  before_action :authenticate_admin_user
  def index
  	@category = Category.find_by(id: params[:category_id])
  	@tabs = @category.tabs.paginate(:page => params[:page], :per_page => 15)
  end

  def new
  	@category = Category.find_by(id: params[:category_id])
    @tab = @category.tabs.new	  
  end

  def create
    binding.pry
    @category = Category.find_by(id: params[:category_id])
     @tab = @category.tabs.new(tab_params)
     if @tab.save
          flash[:notice] =  "Tab created successfully"
          redirect_to admin_category_tabs_path       
     end
    # if @tab.save
    #    @tab_tables = @tab.tab_tables.new(table_name: params[:table_name], table_columns: params[:tab][:column_names].to_unsafe_hash)
    #    if @tab_tables.save
    #       flash[:notice] =  "Tab created successfully"
    #       redirect_to admin_category_tabs_path    
    #    end
    # end
  	
  end

  def show
     # binding.pry
     @tab = Tab.find_by(id: params[:id])
     @column_names = @tab.tab_tables.first.table_name.camelize.constantize.attribute_names - ["_id","updated_at"]
  
  end


  def destroy
    
  end

  def render_table #form_table
      @account_columns = ["name", "contact_person", "contact_email", "contact_mobile", "potential_site", "emp_id"]
      @lead_columns = ["site_name", "location_address", "address", "lat", "long", "account_id", "site_person", "site_mobile", "estimated_value", "sales_emp_id", "attachment", "quotation_id", "emp_remarks", "escalation_one", "escalation_two", "status_one", "status_two", "site_manager_id", "manager_id", "est_close_date", "s1_close_date", "s2_close_date", "manager_remark"] 
      @quotation_columns = ["site_id", "device_quantity", "hub_quantity", "one_time_retail_fee", "manager_approval", "qt_approval_date"] 
      @ddd_columns = [ "quotation_id", "site_id", "site_name", "site_location", "quotation_date", "device_id", "device_type", "attachment", "d3_id", "d3_creation_date", "wh_pickup_date"] 
    
     @tab_type = params[:type]
  end

  def render_table_table
    @column_names = params[:table].camelize.constantize.attribute_names - ["updated_at"]
    @tab_type = params[:type]
  end

  def checkbox_session
    session ||=[]
  @session_hash ||= {}
  @session_hash[params[:table]] ||= {}
  @session_hash[params[:table]]["view"] ||= []
  @session_hash[params[:table]]["view"] << params[:table_column]
  @session <<  @session_hash
  p session
  
  end
  

  private
  def tab_params
    params[:tab][:columns] = params[:tab][:columns].to_unsafe_hash 
    params.require(:tab).permit(:name, :type, :columns)   
  end 
end
