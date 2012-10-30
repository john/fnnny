Fnnny::Application.routes.draw do
  
  root :to => 'home#index'
  
  devise_for :users, path_names: {sign_in: "login", sign_out: "logout"}, controllers: {omniauth_callbacks: "omniauth_callbacks"}
  
  resources :items
  
  match '/people/:id' => 'people#show', :as => :people, :via => :get
  
end
