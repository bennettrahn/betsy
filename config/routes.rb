Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'products#root'
  resources :orders, only: [:index, :show, :edit, :update, :destroy]

  get 'order/:id/checkout', to: 'order#checkout', as: 'checkout'

  resources :products do
    resources :reviews, only: [:new]
  end
  resources :reviews, only: [:create]
  resources :merchants

  resources :order_products, only: [:edit, :update]
  post '/order_products', to: 'order_products#create', as: 'create_order_product'

  get "/auth/:provider/callback", to: "merchants#create", as: 'auth_callback'
  get '/logout', to: 'merchants#logout', as: 'logout'
end
