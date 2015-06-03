Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :social_coupons, only:[:index] do
      put :disable, on: :member
    end
  end
end
