class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product
  validates :cart_item_quantity, numericality: { only_integer: true, greater_than: 0 }
end
