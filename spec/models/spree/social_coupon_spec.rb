require 'spec_helper'

RSpec.describe Spree::SocialCoupon, type: :model do

  describe 'associations' do
    it { is_expected.to belong_to(:promotion_rule) }
    it { is_expected.to belong_to(:order) }
  end

  describe 'validations' do
    context '#code' do
      it { is_expected.to validate_presence_of(:code) }
      it { is_expected.to validate_uniqueness_of(:code) }
    end
  end

  describe '#code=' do
    it 'it downcases the code' do
      social_coupon = build(:social_coupon, code: 'ABCD')
      expect(social_coupon.code).to eq 'abcd'
    end

    it 'strips the code' do
      social_coupon = build(:social_coupon, code: '   ABCD   ')
      expect(social_coupon.code).to eq 'abcd'
    end
  end

  describe '.by_code' do
    let(:social_coupon) { create(:social_coupon, code: 'ABCD') }

    before do
      social_coupon # create the social_coupon
    end

    it 'returns nil unless code is specified' do
      expect(Spree::SocialCoupon.by_code(nil)).to be_nil
    end

    it 'returns the social_coupon with the specified code (case-insensitive)' do
      expect(Spree::SocialCoupon.by_code('ABCD')).to eq social_coupon
    end

    it 'returns the social_coupon with the specified trimmed code' do
      expect(Spree::SocialCoupon.by_code('   ABCD   ')).to eq social_coupon
    end
  end

  describe '.active' do
    let(:active_social_coupon) { create(:social_coupon) }
    let(:disabled_social_coupon) { create(:social_coupon, :consumed) }

    before do
      active_social_coupon
      disabled_social_coupon
    end

    it 'returns active coupons' do
      expect(Spree::SocialCoupon.active.to_a).to eq([active_social_coupon])
    end
  end
end
