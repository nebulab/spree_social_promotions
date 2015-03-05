Spree::PromotionHandler::Coupon.class_eval do
  private

  def handle_present_promotion(promotion)
    return promotion_usage_limit_exceeded if promotion.usage_limit_exceeded?(order)
    return promotion_applied if promotion_exists_on_order?(order, promotion)
    unless promotion.eligible?(order)
      self.error = promotion.eligibility_errors.full_messages.first unless promotion.eligibility_errors.blank?
      return (self.error || ineligible_for_this_order)
    end

    # If any of the actions for the promotion return `true`,
    # then result here will also be `true`.
    result = promotion.activate(:order => order)
    if result
      if promotion.rules.where(type: 'Spree::Promotion::Rules::SocialCouponRule').first
        order.update_totals
        order.persist_totals
        set_success_code :coupon_code_applied
      else
        determine_promotion_application_result
      end
    else
      set_error_code :coupon_code_unknown_error
    end
  end

end
