Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  

  # post 'auth/login', to: 'users#login'
  # get 'test', to: 'users#test'



  api_version(:module => "api/V1", :header => {:name => "Accept", :value => "application/Wavedio; version=1"}) do
  	resources :sessions do
	  	collection do
	  		post :login
	  		post :verify_otp
        post :social_login
	  	end 
  	end
  	resources :static_contents do
  		collection do
  			post :static_contents
  		end
  	end
    resources :devices do
      collection do
        post :search_device
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
      end
    end
  end

end
