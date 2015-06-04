Deface::Override.new(
  virtual_path: "spree/admin/shared/sub_menu/_promotion",
  name: "admin_menu_social_coupons",
  insert_bottom: "ul#sidebar-promotions",
  text: '<%= tab :social_coupons %>',
  disabled: false
)
