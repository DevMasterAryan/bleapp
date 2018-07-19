class UserMailer < ApplicationMailer

	def contact_us message
		@message = message
		mail( :to => "gunjackaryan@gmail.com",
   :subject => 'help email' )
		
	end


	def reset_password user
	  @user = user
	  mail(to: user.email, subject: "Reset Password")
	end
end
