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


	def send_login_credential user_id, temp_password
      @admin = AdminUser.find_by(id: user_id)
      @temp_password = temp_password
	  mail(to: @admin&.email, subject: "Login as #{@admin&.category&.name}")
	end

end
