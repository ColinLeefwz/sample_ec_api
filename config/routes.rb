Rails.application.routes.draw do
  post '/login', to: 'authentication#login'
  get '/users/find', to: 'users#find'
  get '/users/me', to: 'users#me'
  get '/users/me/products', to: 'users#products_list'
  post '/users/:user_id/products/:product_id', to: 'orders#purchase', as: 'order_purchase'
  get '/users/find', to: 'users#find'
  resources :products, only: %i[create index]
  resources :users, only: :create

  get '/*a', to: 'application#not_found'
end
