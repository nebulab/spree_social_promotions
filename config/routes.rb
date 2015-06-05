Spree::Core::Engine.add_routes do
  namespace :admin do
    resources :social_coupons, only:[:index] do
      put :disable, on: :member
    end
  end
end
