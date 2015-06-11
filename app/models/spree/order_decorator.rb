Spree::Order.state_machine.after_transition to: :complete do |order|
  if (social_coupon = Spree::SocialCoupon.active.where(order_id: order.id).first)
    social_coupon.disable!
  end
end
