Rails.application.routes.draw do
  devise_for :users
  root "static_pages#home"
  namespace :backend do
    get "/", to: "static_page#index"

    resources :categories
    resources :requests
    resources :orders
    resources :products do
      collection {post :import}
    end
    resources :users do
      member do
        post :role
      end
    end
  end

  resources :suggests
  resources :comments, only: :create
  resources :users , only: :show
  resources :products
  resources :categories
  resources :orders do
    collection do
      get "checkout"
    end
  end
  resources :carts do
    collection do
      get "addcart"
      get "viewcart"
      get "update_quantity_in_cart"
      delete "destroy"
    end
  end
end
