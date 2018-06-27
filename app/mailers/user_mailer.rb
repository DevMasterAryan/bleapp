class UserMailer < ApplicationMailer

	def contact_us message
		@message = message
		mail( :to => "gunjackaryan@gmail.com",
   :subject => 'help email' )
		
	end
end
