require 'will_paginate/array'
class Admin::AdminUsersController < ApplicationController
  layout 'admin_lte_2'
  before_action :authenticate_admin_user
  def index
    # @admin_user = AdminUser.where(id: session[:user_id]["$oid"]).first
    if params[:search].present?
    @search = AdminUser.any_of({first_name: Regexp.new(".*#{params[:search]}.*","i")},{last_name: Regexp.new(".*#{params[:search]}.*","i")},{emp_id: Regexp.new(".*#{params[:search]}.*","i")},{email: Regexp.new(".*#{params[:search]}.*","i")},{phone: Regexp.new(".*#{params[:search]}.*","i")},{department: Regexp.new(".*#{params[:search]}.*","i")},{designation: Regexp.new(".*#{params[:search]}.*","i")},{territory: Regexp.new(".*#{params[:search]}.*","i")})
    @admin_users = @search.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
    else
    @admin_users = AdminUser.all.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
    end
  end

  def send_credential
    session[:return_to] ||= request.referer
    temp_password = SecureRandom.hex(7)
    AdminUser.find_by(id: params[:admin_user_id]).update(category_id: params[:categories], is_active?: true, password: temp_password, password_confirmation: temp_password)
    user_id = params[:admin_user_id]
    UserMailer.send_login_credential(user_id, temp_password).deliver_now!
    # redirect_to admin_admin_users_path, notice: "Send Successfully"
    redirect_to session[:return_to], notice: "Send Successfully"
    session[:return_to] = nil
  end

  def suspend_user
    session[:return_to] ||= request.referer
    AdminUser.find_by(id: params[:id]).update(is_active?: false)
    # redirect_to admin_admin_users_path, alert: "Suspended"
    redirect_to session[:return_to], alert: "Account Suspended"
    session[:return_to] = nil
  end

  def import
    session[:return_to] ||= request.referer
    AdminUser.import(params[:file])
    # redirect_to admin_admin_users_path, notice: "Users imported"    
    redirect_to session[:return_to], notice: "Users imported"
    session[:return_to] = nil
  end

end