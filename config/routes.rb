Fnnny::Application.routes.draw do
  
  root :to => 'home#index'
  
  devise_for :users, path_names: {sign_in: "login", sign_out: "logout"}, controllers: {omniauth_callbacks: "omniauth_callbacks"}
  
  resources :items
  resources :tags, :id => /[^\/]+/
  
  match '/people/:id' => 'people#show', :as => :people, :via => :get
  match 'people/:id/follow' => 'people#follow', :as => :follow, :via => :get
  match 'people/:id/unfollow' => 'people#unfollow', :as => :unfollow, :via => :get
  
  match '/bookmarklet' => 'home#bookmarklet', :as => :bookmarklet, :via => :get
  
end
