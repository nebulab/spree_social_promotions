FactoryGirl.define do
  # Define your Spree extensions Factories within this file to enable applications, and other extensions to use and override them.
  #
  # Example adding this to your spec_helper will load these Factories for use:
  # require 'spree_social_promotions/factories'

  factory :social_coupon, class: 'Spree::SocialCoupon' do
    sequence(:code) { |n| "coupon-#{n}" }
    promotion_rule factory: :promotion_social_coupon_rule

    disabled false

    trait :consumed do
      association :order
      disabled true
    end
  end

  factory :promotion_social_coupon_rule, class: Spree::Promotion::Rules::SocialCouponRule do
    # association :promotion
  end
end

FactoryGirl.modify do
  factory :promotion, class: Spree::Promotion do
    trait :with_social_coupon_rule do

      after(:create) do |promotion, _evaluator|
        rule = Spree::Promotion::Rules::SocialCouponRule.create!()

        rule << create(:social_coupon, promotion_rule: rule)
        rule << create(:social_coupon, promotion_rule: rule)

        promotion.rules << rule
        promotion.save!
      end
    end

    factory :promotion_with_social_coupon_rule, traits: [:with_social_coupon_rule]
  end
end
