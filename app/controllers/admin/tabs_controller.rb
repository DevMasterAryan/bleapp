class Admin::TabsController < ApplicationController
  def index
  	@category = Category.find_by(id: params[:category_id])
  	@tabs = @category.tabs
  end
end
