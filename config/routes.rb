Rails.application.routes.draw do
  

  namespace :admin do
    resources :categories, only: [:new,:create, :edit, :update]
    resources :accounts 
    get 'accounts/index'
    get 'sessions/login'
    post "sessions/create"
    delete "sessions/destroy"
    get "dashboard/home"
    get "sessions/forgot_password"
    post "password_resets/send_reset_password"
    get "/password_resets/reset_password"
    put "/password_resets/update"
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  

  # post 'auth/login', to: 'users#login'
  # get 'test', to: 'users#test'

  post 'phone_verifications/voice' => 'api/v1/phone_verifications#voice'

  api_version(:module => "api/V1", :header => {:name => "Accept", :value => "application/Wavedio; version=1"}) do
  	resources :sessions do
	  	collection do
	  		post :login
	  		post :verify_otp
        post :social_login
        post :call_verification
        post :logout
	  	end 
  	end
  	resources :static_contents do
  		collection do
  			post :static_contents
        get :faqs
        get :additional_topic
        post :query
  		end
  	end
    resources :devices do
      collection do
        post :search_device
        get :device_locations
        post :stolen_device_location_update
        post :device_location_search
        post :device_status
      end
    end
    resources :packages do
      collection do
        get :packages_list
      end
    end
    resources :users do
      collection do
        post :apply_credit
        post :charge_history
        get :user_last_charge
        get :checksum
      end
    end
    
    resources :help do 
       collection do
         get :get_b1_b2_list
         post :submit_b1_b2
         get :feedback_and_faq_list
       end
    end

    resources :transactions do
      collection do
        post :package_payment
      end
    end

  #   resources :phone_verifications do
  #     collection do
  #       post :voice
  #     end
  #   end
  end

end
