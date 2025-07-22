Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "microposts#index"
    
    resources :microposts, only: [:index]
    resources :users, only: [:show]
    
    get "/help", to: "static_pages#help"
    get "/about", to: "static_pages#about"
    get "/contact", to: "static_pages#contact"
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
  end
end
