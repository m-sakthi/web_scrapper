Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do
      get 'products', to: 'products#index'
      get 'products/fetch', to: 'products#fetch'
      put 'products/update', to: 'products#update'
    end
  end
end
