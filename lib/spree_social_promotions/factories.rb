# require 'spree/testing_support/factories'

FactoryGirl.define do
  # Define your Spree extensions Factories within this file to enable applications, and other extensions to use and override them.
  #
  # Example adding this to your spec_helper will load these Factories for use:
  # require 'spree_social_promotions/factories'

  factory :social_coupon, class: 'Spree::SocialCoupon' do
    sequence(:code) { |n| "coupon-#{n}" }
    # association :promotion_social_coupon_rule
    promotion_rule factory: :promotion_social_coupon_rule

    disabled false

    trait :consumed do
      association :order
      disabled true
    end
  end

  factory :promotion_social_coupon_rule, class: 'Spree::Promotion::Rules::SocialPromoCodeRule' do
    # association :promotion
  end
end

FactoryGirl.modify do
  factory :promotion, class: Spree::Promotion do
    trait :with_social_coupon_rule do

      after(:create) do |promotion, evaluator|
        # cosa ci metto qui dentro? come li metto i coupons?
        #rule = Spree::Promotion::Rules::SocialPromoCode.create!()
        rule = create :promotion_social_coupon_rule
        promotion.rules << rule
        promotion.save!
      end
    end

    factory :promotion_with_social_coupon_rule, traits: [:with_social_coupon_rule]
  end
end
