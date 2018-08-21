class SessionExpireJob < ApplicationJob
  require 'fcm'
  queue_as :default
  require 'notification_keys'
  def perform(user_id)

    user = User.find_by(id: user_id)
    # sender = AdminUser.find_by_id(sender_id)
    # sender = "admin@example.com"
    # User.all.find_each(batch_size: 2000) do |receiver|
    fcm = NotificationKeys::NotiKey.new.fcm_key
    pusher = NotificationKeys::NotiKey.new.apns_key
    if user.user_devices.present?
     # user.each do |user|
    user.user_devices.each do |device|
      if device.device_type=="Android"
        registration_ids = ["#{device.device_token}"] if device.device_token
        options = {"data":{
             'message': ['badge': 1,'alert': "SessionExpire",
            "title": "New message:","body": "", "click_action": "FCM_PLUGIN_ACTIVITY","sound": "default"]},"priority":"high"}
        response = fcm.send_notification(registration_ids,options)

          p "==========#{response.inspect}"
       elsif (device.device_type == 'iOS')
             notification = Grocer::Notification.new(
                  :device_token => device.device_token.to_s,
                  :alert => "",
                  :custom => { :notification_type => "SessionExpire"},
                  :badge => 0,
                  :sound => ""                    
                  )
            push = pusher.push(notification)

            
            p "------------#{push.inspect}"
       end
    # end
  end
  end
    # end
  end

end
