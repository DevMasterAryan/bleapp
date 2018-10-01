class Admin::AccountsController < ApplicationController
  layout 'admin_lte_2'
  before_action :authenticate_admin_user
  def create
    @account  = Account.new(account_params)
    if @account.save
       flash[:notice] = "Account created successfully."
       redirect_to request.referer 
    else   
       flash[:alert] = @account.errors.messages
       redirect_to request.referer

    end	
  end

  def edit
  	
  end

  def update
  	
  end

  private

  def account_params
    params.require(:account).permit(:name, :contact_person, :contact_email, :contact_mobile, :potential_site, :emp_id)  
  end
  
end
