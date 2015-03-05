Spree::Adjustment.class_eval do
  def update!(target = nil)
    return amount if closed?
    if source.present?
      amount = source.compute_amount(target || adjustable)
      self.update_columns(
      amount: amount,
      updated_at: Time.now,
      )
      if promotion? && source.promotion.rules.where(type: 'Spree::Promotion::Rules::SocialCouponRule').empty?
        self.update_column(:eligible, source.promotion.eligible?(adjustable))
      end
    end
    amount
  end
end
