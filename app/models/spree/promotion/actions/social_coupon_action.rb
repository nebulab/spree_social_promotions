module Spree
  class Promotion
    module Actions
      class SocialCouponAction < PromotionAction
        include Spree::CalculatedAdjustments
        include Spree::AdjustmentSource

        has_many :adjustments, as: :source

        delegate :eligible?, to: :promotion

        before_validation -> { self.calculator ||= Spree::Calculator::SocialCoupon.new }

        def perform(options = {})
          order = options[:order]
          return if promotion_credit_exists?(order)

          amount = compute_amount(order)
          return if amount == 0

          # TODO: remove coupon adjustement to any other eventual pending order
          create_adjustment(order, amount)
          # TODO: update social coupon with the current order

          true
        end

        def compute_amount(order)
          amount = self.calculator.compute(order).to_f.abs
          [(order.item_total + order.ship_total), amount].min * -1
        end

        private

        def create_adjustment(order, amount)
          Spree::Adjustment.create!(
            amount: amount,
            order: order,
            adjustable: order,
            source: self,
            label: "#{Spree.t(:promotion)} (#{promotion.name})"
          )
        end

        def promotion_credit_exists?(order)
          self.adjustments.where(adjustable_id: order.id).exists?
        end

      end
    end
  end
end
