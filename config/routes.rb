Rails.application.routes.draw do

  namespace :admin do
    resources :pages do
      get 'version', :on => :member
    end
  end
  match '/static/*path', :to => 'static_content#show', :via => :get, :as => 'static'

end
