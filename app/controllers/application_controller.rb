class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception

  # before_action :authenticate_request
  attr_reader :current_user

  include ExceptionHandler

  protect_from_forgery with: :exception
  
  def authenticate
    auth_token = request.headers[:AUTHTOKEN]
    unless auth_token
      return render_message 501, t('authenticate.failed')
    else
      @api_current_user = User.find_by(access_token: auth_token)
      return render_message 999, t('authenticate.unauthorized') unless @api_current_user
      # return render_message 403, "Please wait for account approval by admin." if @current_user.is_approved == nil and @current_user.is_driver?
       return render_message 503, "You are blocked by admin." if @api_current_user.block_by_admin?
      # @current_user.update_attributes(last_sign_in_at: Time.current)
    end
  end

  def render_message (code, msg)
    render :json => {
      :responseCode => code,
      :responseMessage => msg
    }
  end
  private

  def authenticate_request
  	@current_user = AuthorizeApiRequest.call(request.headers).result
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
	end
end
