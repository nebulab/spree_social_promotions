# A rule to apply to an order greater than (or greater than or equal to)
# a specific quantity of line items
module Spree
  class Promotion
    module Rules
      class SocialCouponRule < PromotionRule
        has_many :social_coupons, dependent: :destroy, foreign_key: 'promotion_rule_id'

        # Generate a random string to be used as a placeholder on the promotion code
        # This is necessary because otherwise promotion will be always applied AND
        # will not check for our social coupons
        #before_create -> { self.promotion.update_attributes(code: SecureRandom.hex(8)) }

        def applicable?(promotable)
          promotable.is_a?(Spree::Order)
        end

        def eligible?(order, options = {})
          social_coupons.by_code(order.coupon_code).present?
        end

        def raw_social_coupons
          ""
        end

        def raw_social_coupons=(coupons)
          all_coupons = coupons.split(/\r?\n/).select(&:present?).map {|c| c.strip.downcase}.sort
          saved_coupons = social_coupons.all.order(code: :asc).pluck(:code)
          (all_coupons.sort - saved_coupons).each do |coupon|
            social_coupons.create(code: coupon)
          end
        end

        private

        def generate_random_promotion_code
          SecureRandom.hex(8)
        end
      end
    end
  end
end
