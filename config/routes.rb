Fnnny::Application.routes.draw do
  
  root :to => 'home#index'
  
  devise_for :users, path_names: {sign_in: "login", sign_out: "logout"}, controllers: {omniauth_callbacks: "omniauth_callbacks"}
  
  resources :comments
  # resources :conversations
  resources :items do
    get :since, :on => :member
    get :before, :on => :member
    get :like, :on => :member
    get :unlike, :on => :member
  end
  match '/items/page/:page' => 'items#more', :as => :more_items, :via => :get
  
  # resources :messages
  # resources :notification
  resources :people
  resources :tags, :id => /[^\/]+/
  
  match '/admin' => 'admin#index', :as => :admin, :via => :get
  match '/bookmarklet' => 'home#bookmarklet', :as => :bookmarklet, :via => :get
  # match '/people/:id' => 'people#show', :as => :person, :via => :get
  match '/people/:id/follow' => 'people#follow', :as => :follow, :via => :get
  match '/people/:id/unfollow' => 'people#unfollow', :as => :unfollow, :via => :get
  
end
