Rails.application.routes.draw do
  
  namespace :admin do
    resources :categories do
       resources :tabs do 
           collection do
             post :render_table
             post :render_table_table
             post :checkbox_session
           end
           resources :notifications, only: [:index]   
       end
    end#, only: [:new,:create, :edit, :update, :index]
    resources :accounts 
    resources :admin_users do
      collection{
        post :import
        post :export
        post :send_credential
        get :suspend_user
      }
    end
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
  
  resources :exportdata do
      collection do
        get :exportxls
      end 
    end
  
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
        post :device_locations
        post :stolen_device_location_update
        post :device_location_search
        post :device_status
        post :save_battery_ts
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
        post :checksum
        post :billing_not_rated
        post :charging_status
        post :checksum_add_money
        post :add_money_transaction_status
        post :billing_status
      end
    end
    
    resources :help do 
       collection do
         get :get_b1_b2_list
         post :submit_b1_b2
         get :feedback_and_faq_list
         get :r1_r2_list
         post :submit_feedback_api
       end
    end

    resources :transactions do
      collection do
        post :package_payment
        post :send_paytm_otp
        post :validate_paytm_otp
        post :check_paytm_balance
        post :validate_paytm_access_token
        post :paytm_withdraw_api
      end
    end

    resources :payment_methods do 
       collection do 
         get :list
         post :add
         post :remove
       end
    end

  #   resources :phone_verifications do
  #     collection do
  #       post :voice
  #     end
  #   end

end

end
