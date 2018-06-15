Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  api_version(:module => "api/V1", :header => {:name => "Accept", :value => "application/Wavedio; version=1"}) do
  	resources :sessions do
	  	collection do
	  		post :login
	  		post :verify_otp
	  	end 
  	end
  end

end
