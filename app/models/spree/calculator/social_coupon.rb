require_dependency 'spree/calculator'

module Spree
  class Calculator::SocialCoupon < Calculator
    preference :amount_before_deadline, :decimal, default: 0
    preference :amount_after_deadline, :decimal, default: 0
    preference :deadline_date, :datetime, default: Time.now
    preference :currency, :string, default: ->{ Spree::Config[:currency] }

    def self.description
      Spree.t(:social_coupon_calculator)
    end

    def compute(order=nil)
      if order && preferred_currency.upcase == order.currency.upcase
        amount_by_date
      else
        0
      end
    end

    private

    def amount_by_date
      if preferred_deadline_date > Time.now
        preferred_amount_before_deadline
      else
        preferred_amount_after_deadline
      end
    end
  end
end
