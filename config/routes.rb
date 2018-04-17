Rails.application.routes.draw do
  devise_for :users, controllers: {
                       sessions: 'users/sessions',
                       registrations: 'users/registrations',
                       passwords: 'users/passwords'
                   }
  as :user do
    get 'login', to: 'users/sessions#new', as: :user_login
    delete 'logout', to: 'devise/sessions#destroy', as: :user_logout
    get 'registration', to: 'users/registrations#new', as: :account_registration
  end

  resources :blogs, only: [:show, :index] do
    resources :comments, only: [:create]
  end

  root to: 'home#index'
  get '/promo/:q/products', to: 'products#index', as: :promotion_products
  post :email_subscription, to: 'public#subscribe'
  resources :wishlists, only: [:index, :destroy]
  resources :products do
    post :review
    resources :wishlists, only: [:create]
    get :quickview
    get :compare
    get :remove_compare
  end

  resources :orders, except: [:index, :new, :create, :destroy] do
    post :populate, on: :collection
    get :reset, on: :collection
    get :shipped_track
  end

  get '/c/*id', to: 'categories#show', as: :categories

  resources :carts
  get '/checkout', to: 'checkout#edit', as: :cart_checkout
  get '/checkout/:state', to: 'checkout#edit', as: :checkout_state
  patch '/checkout/update/:state', to: 'checkout#update', as: :update_checkout
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Payment Gateway

  post '/paypal', :to => "paypal#express", :as => :paypal_express
  get '/paypal/confirm', :to => "paypal#confirm", :as => :confirm_paypal
  get '/paypal/cancel', :to => "paypal#cancel", :as => :cancel_paypal
  get '/paypal/notify', :to => "paypal#notify", :as => :notify_paypal

  # END PAYMENT #

  # Admin routes and resources

  namespace :admin do
    resources :users do
      member do
        get :addresses
        put :addresses
        put :clear_api_key
        put :generate_api_key
        get :items
        get :orders
        get :login
      end
      resources :store_credits
    end
    resources :categories
    resources :brands
    resources :products do
      member do
        get :stock
      end
      resources :images
      resources :variants
    end
    resources :blogs do
      resources :comments, only: [:destroy, :edit, :update]
    end
    resources :home_sliders
    resources :shipping_methods

    resources :payment_methods

    resources :stock_locations do
      member do
        get :stock_items
      end
      resources :stock_movements
    end
    resources :stock_items
    resources :stock_transfers
    get :shipment_tracking, to: 'orders#shipment_tracking'

    resources :orders, except: [:show] do
      member do
        get :cart
        post :resend
        get :open_adjustments
        get :close_adjustments
        put :approve
        put :cancel
        put :resume
      end

      resources :state_changes, only: [:index]

      resource :customer, controller: "orders/customers"
      resources :customer_returns, only: [:index, :new, :edit, :create, :update] do
        member do
          put :refund
        end
      end

      resources :adjustments
      resources :return_authorizations do
        member do
          put :fire
        end
      end
      resources :payments do
        member do
          put :fire
        end

        resources :log_entries
        resources :refunds, only: [:new, :create, :edit, :update]
      end

      resources :reimbursements, only: [:index, :create, :show, :edit, :update] do
        member do
          post :perform
        end
      end
    end
  end
  get '/admin', to: 'admin/dashboard#index', as: :admin

  # public pages

  resources :contacts, only: [:new, :create]
  get '/frequently-asked-question', to: 'public#faq', as: :faq
  get '/secure_shopping', to: 'public#secure_shopping', as: :secure_shopping
  get '/coupon-code', to: 'public#coupon', as: :coupon
  get '/return-policy', to: 'public#return_policy', as: :return_policy
  match '/dedicated-customer-support', to: 'public#contact_us', via: [:get, :post], as: :contact_us
  get '/free-shipping-worldwide', to: 'public#international', as: :international
  get '/safe_shopping_guarantee', to: 'public#safe_shopping_guarantee', as: :safe_shopping_guarantee
  get '/about_us', to: 'public#about_us', as: :about_us
  get '/privacy_policy', to: 'public#privacy_policy', as: :privacy_policy
  get '/term_condition', to: 'public#term_condition', as: :term_condition
  get '/my_account', to: 'users#my_account'
  get '/cart', to: 'public#cart'
  get '/p_checkout', to: 'public#checkout'
  post '/email_subscription', to: 'public#subscribe'
end
