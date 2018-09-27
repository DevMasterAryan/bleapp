require 'will_paginate/array'
class Admin::NotificationsController < ApplicationController
  layout 'admin_lte_2'
  before_action :authenticate_admin_user

  def index
    # @admin_user = AdminUser.where(id: session[:user_id]["$oid"]).first
    # category  = Category.find_by(name: "SuperAdmin")
    if params[:search].present?
    @search = AdminUser.any_of({first_name: Regexp.new(".*#{params[:search]}.*","i")},{last_name: Regexp.new(".*#{params[:search]}.*","i")},{emp_id: Regexp.new(".*#{params[:search]}.*","i")},{email: Regexp.new(".*#{params[:search]}.*","i")},{phone: Regexp.new(".*#{params[:search]}.*","i")},{department: Regexp.new(".*#{params[:search]}.*","i")},{designation: Regexp.new(".*#{params[:search]}.*","i")},{territory: Regexp.new(".*#{params[:search]}.*","i")})
    @users = @search.where(:category_id.nin=> Category.where(name: "SuperAdmin").pluck(:id)).order("created_at desc").paginate(:page => params[:page], :per_page => 10)
    # AdminUser.where(:category_id.nin=> Category.where(name: "SuperAdmin").pluck(:id))
    else
    @users = AdminUser.where(:category_id.nin=> Category.where(name: "SuperAdmin").pluck(:id)).order("created_at desc").paginate(:page => params[:page], :per_page => 10)
    end

    @notifications = Notification.all.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
  end

  def notify
      @tab  = Tab.find_by(id: params[:tab_id])
      @notify = @tab.notifications.where(admin_user_id: params[:user_id], type: params[:type]).first
      if @notify.present?  
        @notify.update(type: params[:type])
        flash[:notice] = "User Added Successfully."
        redirect_to admin_category_tab_notifications_path(params[:category_id], @tab)
      else
       @notification =  @tab.notifications.new(notification_params)
        if @notification.save
          flash[:notice] = "User Added Successfully."
          redirect_to  admin_category_tab_notifications_path(params[:category_id], @tab)
        end  
      end      
   end

   def destroy
     @notification = Notification.find_by(id: params[:id])
     @notification.destroy
     redirect_to request.referer, notice: "Deleted Successfully"
   end


  private
  def notification_params
    params[:admin_user_id]= params[:user_id]
    params.permit(:admin_user_id, :type)
  end
end
