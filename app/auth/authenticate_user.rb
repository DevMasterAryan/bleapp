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
			user = User.find_by(e_mail: email)
		else
			user = User.find_by(mobile_no: email)
		end

		return user if user #&& (user.mobile_no == password)

		errors.add :user_authentication, 'Invalid Credentials'
		nil 
	end
end