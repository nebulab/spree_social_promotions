class CreateSpreeSocialCoupons < ActiveRecord::Migration
  def change
    create_table :spree_social_coupons do |t|
      t.string :code
      t.integer :promotion_rule_id
      t.integer :order_id
      t.boolean :disabled, default: false

      t.timestamps
    end
  end
end
