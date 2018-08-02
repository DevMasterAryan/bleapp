class NotificationJob < ApplicationJob
  
  queue_as :default
  require 'notification_keys'
  # def perform()
  #   # sender = AdminUser.find_by_id(sender_id)
  #   sender = "admin@example.com"
  #   User.all.find_each(batch_size: 2000) do |receiver|
  #   fcm = NotificationKeys::NotiKey.new.fcm_key
  #   pusher = NotificationKeys::NotiKey.new.apns_key
  #   receiver.devices.each do |device|
  #       if device.device_type=="android"

  #         registration_ids = ["#{device.device_token}"] if device.device_token
  #         options = {"data":{
  #            'message': ['badge': 1,'alert': "Notification",
  #           "title": "New message:","body": "You got a new notification from #{sender}.", "click_action": "FCM_PLUGIN_ACTIVITY","sound": "default"]},"priority":"high"}
  #         response = fcm.send_notification(registration_ids,options)

  #         p "==========#{response.inspect}"
  #       elsif (device.device_type == 'iOS')
  #            notification = Grocer::Notification.new(
  #                 :device_token => device.device_token.to_s,
  #                 :alert => "You got a new notification from #{sender}.",
  #                 :custom => { :notification_type => "UserNotification" },
  #                 :badge => 1,
  #                 :sound => "default"                    
  #                 )
  #           push = pusher.push(notification)
  #           p "------------#{push.inspect}"
  #       end
  #     end
  #   end
  # end


  def perform()
    
    pusher = NotificationKeys::NotiKey.new.apns_key
    notification = Grocer::Notification.new(
                   :device_token => "5244303420BF8B8DAFAD7D938CAA7A356CC5CD4F0EC55FE6D7DD7A92E282A234",
                   :alert => "You got a new notification from dinga.",
                   :custom => { :notification_type => "UserNotification" },
                   :badge => 1,
                   :sound => "default"                    
                   )
  push = pusher.push(notification)
  end
end
