class Admin::CategoriesController < ApplicationController
  layout 'admin_lte_2'
  before_action :authenticate_admin_user

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
          redirect_to admin_dashboard_home_path
       end
    end
  end

  def edit
  end

  def update
  end
end
