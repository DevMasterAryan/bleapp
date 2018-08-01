module NotificationKeys
  class NotiKey
    def fcm_key
      fcm = FCM.new("AAAAObq6nOU:APA91bFOp6AP2kpzaKlw3odguhM0DRA3CN9-rVeccm-Myvsp5qJGHpEKNavuW_4-uhdHPZ3umFkR9EZcI9ShE8l1P1zxyCWLCDOKx0smwFkyq9e87sRqw0zAH3lKJQnvkD5NZhcn-qvo6qFqt9-rDHVHakrTO8c9kA")
    end

    def apns_key
      pusher = Grocer.pusher(
          certificate: Rails.root.join('mobiloitteenterprisedistribution.pem'),
          passphrase:  "Mobiloitte1",                               
          gateway:     "gateway.push.apple.com", 
          port:        2195,                    
          retries:     3                        
           )
    end
  end
end