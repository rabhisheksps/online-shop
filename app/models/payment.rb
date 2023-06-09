class Payment < ApplicationRecord
  attr_accessor :credit_card_number, :credit_card_exp_month, :credit_card_exp_year, :credit_card_cvv
  belongs_to :order
  # before_validation :create_on_stripe
  # before_checkout :check_order_quantity

  # def check_order_quantity
  #   cart_items = current_user.cart_items
  #   cart_items.includes(:product).each do |cart_item|
  #     if cart_item.product.stock_quantity <= cart.cart_item_quantity
  #       redirect_to products_path, notice: "Order quantity must be less than available stock"
  #     end
  #   end
  # end
end
