module Spree
  module Admin
    class SocialCouponsController < Spree::Admin::ResourceController
      def index
        if params[:coupon_code]
          @social_coupon = Spree::SocialCoupon.active.by_code(params[:coupon_code])
        end
      end

      def disable
        social_coupon = Spree::SocialCoupon.active.find(params[:id])

        if social_coupon
          social_coupon.disable!
          flash[:notice] = 'Social Coupon Code was successfully disabled'
        else
          flash[:alert] = 'Social Coupon Code not found! Perhaps is already disabled?'
        end

        redirect_to action: :index # TODO: review syntax here
      end

    end
  end
end
