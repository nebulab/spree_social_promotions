Spree::Promotion.class_eval do
  has_many :social_coupons, through: :promotion_rules, source: :promotion

  def self.with_coupon_code(coupon_code)
    coupon_code = coupon_code.strip.downcase

    where("lower(#{self.table_name}.code) = ?", coupon_code).first ||

    # doesn't work!
    #includes(:social_coupons).where('social_coupons_spree_promotions.code' => coupon_code).first

    # uglier, but it works!
    Spree::Promotion::Rules::SocialCouponRule.
      includes(:social_coupons).
      where('spree_social_coupons.code' => coupon_code).
      first.try(:promotion)
  end
end
