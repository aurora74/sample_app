Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
  root "microposts#index"
  
  resources :microposts, only: %i[index]
  resources :users, only: %i[show]
  
  get "/help", to: "static_pages#help"
  get "/about", to: "static_pages#about"
  get "/contact", to: "static_pages#contact"
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  end
end
