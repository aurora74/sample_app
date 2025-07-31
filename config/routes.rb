Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
  root "microposts#index"
  
  resources :microposts, only: %i[index create destroy]
  resources :users, only: %i[index show new create edit update destroy]
  resources :account_activations, only: %i[edit]
  resources :password_resets, only: %i[new create edit update]
  
  get "/help", to: "static_pages#help"
  get "/about", to: "static_pages#about"
  get "/contact", to: "static_pages#contact"
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get "/logout_and_login", to: "sessions#logout_and_login"
  end
end
