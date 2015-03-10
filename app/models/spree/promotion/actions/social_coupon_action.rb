module Spree
  class Promotion
    module Actions
      class SocialCouponAction < PromotionAction
        include Spree::CalculatedAdjustments
        include Spree::AdjustmentSource

        has_many :adjustments, as: :source
        delegate :eligible?, to: :promotion

        before_validation -> { self.calculator ||= Spree::Calculator::SocialCoupon.new }
        before_destroy :deals_with_adjustments_for_deleted_source

        def perform(options = {})
          order = options[:order]
          return if promotion_credit_exists?(order)

          amount = compute_amount(order)
          return if amount == 0

          # remove coupon adjustement to any other eventual pending order
          social_coupon = Spree::SocialCoupon.active.by_code(order.coupon_code)
          return unless social_coupon

          # find eventual previous uncompleted order
          old_order = social_coupon.order
          if old_order && !old_order.completed?
            old_order.adjustments.promotion.each do |adjustment|
              # destroy social coupon adjustement, if any
              adjustment.update(eligible: false) if adjustment.source.type == 'Spree::Promotion::Actions::SocialCouponAction'
              adjustment.destroy if adjustment.source.type == 'Spree::Promotion::Actions::SocialCouponAction'
            end
            # force update on the old order to recalculate adjustments
            old_order.update!
          end

          create_adjustment(order, amount) &&
          # update social coupon with the current order
          social_coupon.update_attributes(order: order)
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
