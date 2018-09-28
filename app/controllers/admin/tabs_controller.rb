require 'will_paginate/array'

class Admin::TabsController < ApplicationController
  layout 'admin_lte_2'
  before_action :authenticate_admin_user
  def index
  	@category = Category.find_by(id: params[:category_id])
  	@tabs = @category.tabs.order("created_at desc").reverse.paginate(:page => params[:page], :per_page => 15)
  end

  def new
  	@category = Category.find_by(id: params[:category_id])
    @tab = @category.tabs.new	  
  end

  def create
    @category = Category.find_by(id: params[:category_id])
     @tab = @category.tabs.new(tab_params)
     if @tab.save
          @tab.update(columns: params[:tab][:columns].to_unsafe_hash)
          flash[:notice] =  "Tab created successfully"
          redirect_to admin_category_tabs_path       
     end
  end

  def show
    @tab = Tab.find_by(id: params[:id])
    @show = @tab.columns
    @show_tabs = @tab.columns.keys 
   
  end

  def edit
   @tab = Tab.find_by(id: params[:id])
   @show = @tab.columns
   @show_tabs = @tab.columns.keys 
   if @tab.type == 'form'
    @account_columns = ["name", "contact_person", "contact_email", "contact_mobile", "potential_site", "emp_id"]
    @lead_columns = ["site_name", "location_address", "address", "lat", "long", "account_id", "site_person", "site_mobile", "estimated_value", "sales_emp_id", "attachment", "quotation_id", "emp_remarks", "escalation_one", "escalation_two", "status_one", "status_two", "site_manager_id", "manager_id", "est_close_date", "s1_close_date", "s2_close_date", "manager_remark"] 
    @quotation_columns = ["site_id", "device_quantity", "hub_quantity", "one_time_retail_fee", "manager_approval", "qt_approval_date"] 
    @ddd_columns = [ "quotation_id", "site_id", "site_name", "site_location", "quotation_date", "device_id", "device_type", "attachment", "d3_id", "d3_creation_date", "wh_pickup_date"] 
   elsif @tab.type == 'table'
    @account_columns = ["_id","created_at","name", "contact_person", "contact_email", "contact_mobile", "potential_site", "emp_id"]
    @lead_columns = ["_id","created_at","site_name", "location_address", "address", "lat", "long", "account_id", "site_person", "site_mobile", "estimated_value", "sales_emp_id", "attachment", "quotation_id", "emp_remarks", "escalation_one", "escalation_two", "status_one", "status_two", "site_manager_id", "manager_id", "est_close_date", "s1_close_date", "s2_close_date", "manager_remark"] 
    @quotation_columns = ["_id","created_at","site_id", "device_quantity", "hub_quantity", "one_time_retail_fee", "manager_approval", "qt_approval_date"] 
    @ddd_columns = [ "_id","created_at","quotation_id", "site_id", "site_name", "site_location", "quotation_date", "device_id", "device_type", "attachment", "d3_id", "d3_creation_date", "wh_pickup_date"]  
   end

  end

  def update
    binding.pry
     @tab = Tab.find_by(id: params[:id])
     if @tab.update(name: params[:tab][:name], columns: params[:tab][:columns].to_unsafe_hash)
      redirect_to admin_category_tabs_path, notice: "Tab Updated Successfully"
    end
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
      @account_columns = ["_id","created_at","name", "contact_person", "contact_email", "contact_mobile", "potential_site", "emp_id"]
      @lead_columns = ["_id","created_at","site_name", "location_address", "address", "lat", "long", "account_id", "site_person", "site_mobile", "estimated_value", "sales_emp_id", "attachment", "quotation_id", "emp_remarks", "escalation_one", "escalation_two", "status_one", "status_two", "site_manager_id", "manager_id", "est_close_date", "s1_close_date", "s2_close_date", "manager_remark"] 
      @quotation_columns = ["_id","created_at","site_id", "device_quantity", "hub_quantity", "one_time_retail_fee", "manager_approval", "qt_approval_date"] 
      @ddd_columns = [ "_id","created_at","quotation_id", "site_id", "site_name", "site_location", "quotation_date", "device_id", "device_type", "attachment", "d3_id", "d3_creation_date", "wh_pickup_date"]  
      @tab_type = params[:type]
    # @column_names = params[:table].camelize.constantize.attribute_names - ["updated_at"]
    # @tab_type = params[:type]
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

  def create_session
    if session[:table_name].present?
       params[:table_name]
       
    else
      session[:table_name] ||= [] 
      session[:table_name] << params[:table_name]  
    end
    
  end
  

  private
  def tab_params
    # params[:tab][:columns] = params[:tab][:columns].to_unsafe_hash 
    params.require(:tab).permit(:name, :type)   
  end 
end
