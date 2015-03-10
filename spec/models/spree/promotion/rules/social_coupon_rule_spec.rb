require 'spec_helper'

describe Spree::Promotion::Rules::SocialCouponRule, type: :model do
  let (:promotion) { create :promotion, :with_social_coupon_rule }
  let (:rule) { promotion.rules.first }
  let(:social_coupon) { create(:social_coupon, code: 'ABC') }
  let(:order) { Spree::Order.new(coupon_code: 'ABC') }

  before do
    rule.social_coupons << social_coupon
  end

  describe 'associations' do
    it { is_expected.to have_many(:social_coupons) }
  end

  describe '#eligible?(order)' do
    it 'is eligible if social coupon exists' do
      expect(rule).to be_eligible(order)
    end
  end

  describe '#applicable?' do
    it 'is applicable if promotable is an order' do
      expect(rule).to be_applicable(order)
    end
  end

  describe '#raw_social_coupons' do
    it 'returns an empty string' do
      expect(rule.raw_social_coupons).to eq('')
    end
  end

  describe '#raw_social_coupons=' do
    let(:raw_social_coupons) { "DEF\nGHI" }

    it 'creates social coupons' do
      expect {
        rule.raw_social_coupons = raw_social_coupons
      }.to change { rule.social_coupons.count }.by(2)
    end

    it 'skips duplicated social coupons' do
      expect {
        rule.raw_social_coupons = 'ABC'
      }.to_not change { rule.social_coupons.count }
    end
  end
end
