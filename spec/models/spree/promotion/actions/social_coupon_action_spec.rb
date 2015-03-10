require 'spec_helper'

describe Spree::Promotion::Actions::SocialCouponAction, type: :model do
  let(:order) { create(:order_with_line_items, line_items_count: 1) }
  let (:promotion) { create :promotion, :with_social_coupon_rule }
  let(:calculator) {
    Spree::Calculator::SocialCoupon.new(
      preferred_amount_before_deadline: 50,
      preferred_amount_after_deadline: 25,
      preferred_deadline_date: Time.now + 3.days
    )
  }
  let(:action) { Spree::Promotion::Actions::SocialCouponAction.new() }
  let(:payload) { { order: order } }
  let(:social_coupon) { create :social_coupon, code: 'ABC' }

  before do
    social_coupon
    order.coupon_code = 'ABC'
    promotion
    payload
  end

  describe "#perform" do
    before do
      action.calculator = calculator
      promotion.rules.first.social_coupons << social_coupon
      promotion.promotion_actions = [action]
      allow(action).to receive_messages(promotion: promotion)

      action.perform(payload)
    end

    it "should create a discount with correct negative amount" do
      expect(promotion.credits_count).to eq(1)
      expect(order.adjustments.count).to eq(1)
      expect(order.adjustments.first.amount.to_i).to eq(-50)
    end

    it "should create a discount accessible through both order_id and adjustable_id" do
      expect(order.adjustments.count).to eq(1)
      expect(order.all_adjustments.count).to eq(1)
    end

    it "does not create a discount when order already has one from this promotion" do
      action.perform(payload)
      expect(order.adjustments.count).to eq(1)
      expect(promotion.credits_count).to eq(1)
    end
  end

  context "#destroy" do
    before(:each) do
      action.calculator = calculator
      promotion.promotion_actions = [action]

      action.perform(payload)
      action.destroy
    end

    context "when order is not complete" do
      it "should not keep the adjustment" do
        expect(order.adjustments.count).to eq(0)
      end
    end

    context "when order is complete" do
      let(:order) do
        create(:completed_order_with_totals, :line_items_count => 1)
      end

      it "should keep the adjustment" do
        expect(order.adjustments.count).to eq(1)
      end

      it "should nullify the adjustment source" do
        expect(order.adjustments.reload.first.source).to be_nil
      end
    end
  end

end
