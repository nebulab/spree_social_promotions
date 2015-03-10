# A rule to apply to an order greater than (or greater than or equal to)
# a specific quantity of line items
module Spree
  class Promotion
    module Rules
      class SocialCouponRule < PromotionRule
        has_many :social_coupons, dependent: :destroy, foreign_key: 'promotion_rule_id'

        def applicable?(promotable)
          promotable.is_a?(Spree::Order)
        end

        def eligible?(order, options = {})
          social_coupons.active.by_code(order.coupon_code).present?
        end

        def raw_social_coupons
          ''
        end

        def raw_social_coupons=(coupons)
          all_coupons = coupons.split(/\r?\n/).select(&:present?).map {|c| c.strip.downcase}.sort
          saved_coupons = social_coupons.all.order(code: :asc).pluck(:code)
          (all_coupons.sort - saved_coupons).each do |coupon|
            social_coupons.create(code: coupon)
          end
        end
      end
    end
  end
end
