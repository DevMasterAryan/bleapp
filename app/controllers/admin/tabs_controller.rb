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
  	
  end

  def destroy
    
  end

  def render_table
     @column_names = params[:table].camelize.constantize.attribute_names - ["created_at", "updated_at"]
     @tab_type = params[:type]
  end

end
