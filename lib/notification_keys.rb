module NotificationKeys
  class NotiKey
    def fcm_key
      fcm = FCM.new("AAAA2qgWFUE:APA91bG5MkH5Mc664AUNi_lMfWKjcM4b8VNMZS7yFP-RbJEvTRz4GOP-QfYjf-tuIr6UG-T77oobcApjYBAGkLMeR3jhku-xW4LCo63xSQ8ldXELR52vITrXvK-DskD43UzaQTKw_ntb")
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