Rails.application.config.spree.promotions.rules << Spree::Promotion::Rules::SocialCouponRule
Rails.application.config.spree.promotions.actions << Spree::Promotion::Actions::SocialCouponAction

Rails.application.config.spree.calculators.add_class('promotion_actions_social_coupon_actions')
Rails.application.config.spree.calculators.promotion_actions_social_coupon_actions = [
  Spree::Calculator::SocialCoupon
]
