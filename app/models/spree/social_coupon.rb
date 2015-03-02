class Spree::SocialCoupon < ActiveRecord::Base
  belongs_to :promotion
  belongs_to :order

  validates :code,
    presence: true,
    uniqueness: { case_sensitive: false }

  validates :promotion, presence: true

  def code=(value)
    write_attribute(:code, value.downcase.strip) if value
  end

  def self.by_code(code)
    return nil unless code
    where(code: code.downcase.strip).first
  end
end
