class NotificationJob < ApplicationJob
  require 'fcm'
  queue_as :default
  require 'notification_keys'
  def perform(user_id, promotion_count)
    user = User.find_by(id: user_id)
    # sender = AdminUser.find_by_id(sender_id)
    # sender = "admin@example.com"
    # User.all.find_each(batch_size: 2000) do |receiver|
    fcm = NotificationKeys::NotiKey.new.fcm_key
    pusher = NotificationKeys::NotiKey.new.apns_key
    user.user_devices.each do |device|
        if device.device_type=="Android"

          registration_ids = ["#{device.device_token}"] if device.device_token
          options = {"data":{
             'message': ['badge': 1,'alert': "PromotionNotification",
            "title": "New message:","body": "Use free charge - #{promotion_count} added to your account.", "click_action": "FCM_PLUGIN_ACTIVITY","sound": "default",promotion_count: "#{promotion_count}"]},"priority":"high"}
          response = fcm.send_notification(registration_ids,options)

          p "==========#{response.inspect}"
        elsif (device.device_type == 'iOS')
             notification = Grocer::Notification.new(
                  :device_token => device.device_token.to_s,
                  :alert => "Use free charge - #{promotion_count} promotion added to your account.",
                  :custom => { :notification_type => "PromotionNotification", :promotion_count => "#{promotion_count}" },
                  :badge => 1,
                  :sound => "default"                    
                  )
            p "....notification.................#{notification.inspect} ................."
            p "................................." 
            push = pusher.push(notification)
            p "--push----------#{push.inspect}"
        end
      end
    # end
  end


  # def perform()
  #   fcm = NotificationKeys::NotiKey.new.fcm_key
  #   registration_ids = ["fOfJ1JhppLY:APA91bE17G4M0m4S4mN-2zFoxU1oEhJ8dvVCyRGbwkXR8woB6B_7F095Vh5LqRruxRiJTzj2yWIKcG9RD8Y7FHcVBnzoDDReMFlFm_l9EZtcXqtWJV2XWLlYx_lsZy95-eqNyzjMm2ViwuLpSIzbVN8Cs-lzvDLDiQ"] 
  #   options = {"data":{
  #             'message': ['badge': 1,'alert': "Notification",
  #            "title": "New message:","body": "You got a new notification from Wavedio.", "click_action": "FCM_PLUGIN_ACTIVITY","sound": "default"]},"priority":"high"}
  #         response = fcm.send_notification(registration_ids,options)

    
  # #   pusher = NotificationKeys::NotiKey.new.apns_key
  # #   notification = Grocer::Notification.new(
  # #                  :device_token => "5244303420BF8B8DAFAD7D938CAA7A356CC5CD4F0EC55FE6D7DD7A92E282A234",
  # #                  :alert => "You got a new notification from dinga.",
  # #                  :custom => { :notification_type => "UserNotification" },
  # #                  :badge => 1,
  # #                  :sound => "default"                    
  # #                  )
  # # push = pusher.push(notification)
  # end
end
