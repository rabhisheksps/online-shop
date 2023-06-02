class Wishlist < ApplicationRecord
  belongs_to :user
  has_many :wishlist_products
  has_many :products, through: :wishlist_products
end
