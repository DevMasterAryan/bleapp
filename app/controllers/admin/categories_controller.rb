require 'will_paginate/array'
class Admin::CategoriesController < ApplicationController
  layout 'admin_lte_2'
  before_action :authenticate_admin_user

  def index
    if params[:search].present?
    @search = Category.any_of({name: Regexp.new(".*#{params[:search]}.*","i")})
    @categories = @search.where(:id.nin=> Category.where(name: "SuperAdmin").pluck(:id)).order("created_at desc").paginate(:page => params[:page], :per_page => 15)
    else
    @categories = Category.where(:id.nin=> Category.where(name: "SuperAdmin").pluck(:id)).order("created_at desc").paginate(:page => params[:page], :per_page => 15)
    end    
  end

  def new
  end

  def create
    if Category.where(name: params[:category][:name]).first.present?
       flash[:alert] = "Category with this name already exist."
       render 'new'
    else
       category = Category.new(name: params[:category][:name])  
       if category.save
          flash[:notice] = "Category created successfully."
          redirect_to admin_categories_path
       end
    end
  end

  def edit
  end

  def update
  end
end
