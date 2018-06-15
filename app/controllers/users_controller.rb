class UsersController < ApplicationController
	skip_before_action :authenticate_request, only: %i[login]

	def login
		type1 = params[:email].present? ? "email" : "mobile"
		value = params[:email].present? ? params[:email] : params[:mobile_no]
    authenticate value, type1
  end
  
  def test
    render json: {
          message: 'You have passed authentication and authorization test'
        }
  end


  private 

  def authenticate(email, type)
    command = AuthenticateUser.call(email, type)

    if command.success?
      render json: {
        access_token: command.result,
        message: 'Login Successful'
      }
    else
      render json: { error: command.errors }, status: :unauthorized
    end
  end

end
