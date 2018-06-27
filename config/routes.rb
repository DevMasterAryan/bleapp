Rails.application.routes.draw do
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
        get :charge_history
        get :user_last_charge
      end
    end

  #   resources :phone_verifications do
  #     collection do
  #       post :voice
  #     end
  #   end
  end

end
