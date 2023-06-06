class Cart < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :cart, optional: true
  has_many :cart_items
  has_many :products, through: :cart_items

  before_save :subtotal, :total

  def subtotal
    self.subtotal = 0
    self.cart_items.each do |cart_item|
      product = cart_item.product
      self.subtotal = (product.price * cart_item.cart_item_quantity)
    end
  end

  def total
    self.total = 0
    self.cart_items.each do |cart_item|
      product = cart_item.product
      self.total = (product.price * cart_item.cart_item_quantity) + product.tax + product.shipping_fees
    end
  end

  
end
