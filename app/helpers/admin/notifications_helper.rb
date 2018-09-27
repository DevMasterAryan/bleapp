module Admin::NotificationsHelper
	def user id
		AdminUser.find_by(id: id)
	end
end
