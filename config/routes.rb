Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :orders
  resources :products
  resources :merchants
  post '/order_products', to: 'order_products#create', as: 'create_order_product'
end
