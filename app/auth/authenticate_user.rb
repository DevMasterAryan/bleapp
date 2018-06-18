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
		else
			user = User.where(mobile_no: email).first
		end

		return user if user #&& (user.mobile_no == password)

		errors.add :user_authentication, 'Invalid Credentials'
		nil 
	end
end