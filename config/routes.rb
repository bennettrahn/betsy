Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :orders
  resources :products do
    resources :reviews, only: [:new, :create, :show]
  end
  resources :merchants
  post '/order_products', to: 'order_products#create', as: 'create_order_product'

  get "/auth/:provider/callback", to: "merchants#create", as: 'auth_callback'
  get '/logout', to: 'merchants#logout', as: 'logout'
end
