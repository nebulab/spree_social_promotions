class Spree::SocialCoupon < ActiveRecord::Base
  belongs_to :promotion_rule
  belongs_to :order

  validates :code,
    presence: true,
    uniqueness: { case_sensitive: false }

  validates :promotion_rule, presence: true

  scope :active, -> { where(disabled: false) }

  def code=(value)
    write_attribute(:code, value.strip.downcase) if value
  end

  def self.by_code(code)
    return nil unless code
    where(code: code.strip.downcase).first
  end

  def disable!
    self.update_attributes(disabled: true)
  end
end
