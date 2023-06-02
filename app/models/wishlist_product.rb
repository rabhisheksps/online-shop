class WishlistProduct < ApplicationRecord
  belongs_to :wishlist
  belongs_to :product
  
  validates_uniqueness_of :product
end
