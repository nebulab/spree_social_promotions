Deface::Override.new(
  virtual_path: "spree/admin/shared/_promotion_sub_menu",
  name: "admin_menu_social_coupons",
  insert_bottom: "ul#sub_nav[data-hook='admin_promotion_sub_tabs']",
  text: '<%= tab :social_coupons %>',
  disabled: false
)
