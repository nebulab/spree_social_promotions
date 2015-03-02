FactoryGirl.define do
  # Define your Spree extensions Factories within this file to enable applications, and other extensions to use and override them.
  #
  # Example adding this to your spec_helper will load these Factories for use:
  # require 'spree_social_promotions/factories'

  factory :social_coupon, class: 'Spree::SocialCoupon' do
    sequence(:code) { |n| "coupon-#{n}" }
    association :promotion
    disabled false

    trait :consumed do
      association :order
      disabled true
    end
  end
end
