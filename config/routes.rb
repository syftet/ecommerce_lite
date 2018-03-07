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

  root to: 'home#index'
  get '/promo/:q/products', to: 'products#index', as: :promotion_products
  post :email_subscription, to: 'public#subscribe'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Admin routes and resources

  namespace :admin do
    resources :users
    resources :categories
    resources :brands
    resources :products
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
