Rails.application.routes.draw do
  
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root "products#index"
  
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  devise_scope :user do  
    get '/users/sign_out' => 'devise/sessions#destroy'     
 end

  namespace :admin do
    resources :products do
      member do
        put :approve
        put :reject
      end
    end
  end
  resources :products do
    resources :carts, only: %i[new create]
  end 
    
  resources :users do
    resources :products, only: %i[new create]
  end

  resources :orders do
    resources :payments, only: %i[new create]
  end 

  resources :products do
    member do
      get :add_to_wishlist
    end
  end

  resources :subcategories do
    get 'all_products', to: 'products#all_products'
  end
  
  resources :carts, only: %i[index] do
    get '/checkout', to: 'payments#checkout'
  end
  
  resources :users do
    resources :addresses, only: %i[new create]
  end

  resources :categories do
    resources :subcategories, only: %i[new create index]
  end

  # resources :cart do
  #   resources :products
  # end

  resources :carts, only: %i[index] do
    get :add_item
    post :add_item
    # delete :remove_item
    # patch :update_item_quantity
  end

  resources :cart_items, only: %i[destroy] 

  # resources :cart_items do
  #   member do
  #     patch 'increase_count'
  #   end
  # end

  resources :addresses, except: %i[new create]
  resources :wishlists, except: %i[destroy]
  resources :wishlist_products, only: %i[index show]
  resources :products, except: %i[new create]
  resources :orders, except: %i[new create]
  resources :categories
  resources :subcategories, except: %i[new create index]
  get '/search_product', to: 'products#search_product'
  get '/my_products', to: 'products#my_products'
  get '/about_us', to: "users#about_us"
  post 'checkout', to: 'payments#checkout'
  post 'webhooks/payments/update_status', to: 'webhooks/payments#update_status'
  post 'webhooks/payments/cancel', to: 'webhooks/payments#cancel'
  get 'checkout_status', to: 'payments#checkout_status'
  resources :cart_items, only: %i[edit update]
  get 'user_card_info', to: 'card_infos#show'
end
