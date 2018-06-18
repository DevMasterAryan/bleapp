require 'json_web_token'
class AuthenticateUser
	prepend SimpleCommand

	attr_accessor :email, :password


	def initialize(email, type)
		@email = email
		@password = password
		@type = type
	end

	def call
		JsonWebToken.encode(user_id: user.id) if user
	end

	private

	def user
		if (@type == "email")
			user = User.whrere(e_mail: email).first
		elsif @type == "mobile"
			user = User.where(mobile_no: email).first
		else
			errors.add :user_authentication, 'Invalid Credentials'
			nil 			
		end
		return user if user #&& (user.mobile_no == password)
	end
end