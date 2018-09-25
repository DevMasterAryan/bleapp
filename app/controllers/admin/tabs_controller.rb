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
    @category = Category.find_by(id: params[:category_id])
    @tab = @category.tabs.new(name: params[:tab][:name], type: params[:tab][:type])
    if @tab.save
       @tab_tables = @tab.tab_tables.new(table_name: params[:table_name], table_columns: params[:tab][:column_names].to_unsafe_hash)
       if @tab_tables.save
          flash[:notice] =  "Tab created successfully"
          redirect_to admin_category_tabs_path    
       end
    end
  	
  end

  def destroy
    
  end

  def render_table
     @column_names = params[:table].camelize.constantize.attribute_names - ["_id","updated_at"]
     @tab_type = params[:type]
  end

end
