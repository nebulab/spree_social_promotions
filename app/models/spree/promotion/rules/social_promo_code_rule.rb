# A rule to apply to an order greater than (or greater than or equal to)
# a specific quantity of line items
module Spree
  class Promotion
    module Rules
      class SocialPromoCodeRule < PromotionRule
        # has_many :social_coupons
        # accept_nested_attributes_for :social_coupons

        def applicable?(promotable)
          promotable.is_a?(Spree::Order)
        end

        def eligible?(order, options = {})
          true
        end

        def social_coupons
          promotion.social_coupons
        end

        def social_coupons=(coupons)
        end
      end
    end
  end
end
