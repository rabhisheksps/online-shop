class Product < ApplicationRecord
  
  paginates_per 5
  max_paginates_per 3
  max_pages 3
  
  validates_presence_of :product_name, :price, :material, :vendor, :description, :stock_quantity,
                         :shipping_fees, :tax, :category, :subcategory
  validates_acceptance_of :available                      
  validates_numericality_of :price, :stock_quantity, :shipping_fees, :tax, on: :create, message: "is not a number"
  validates :price, :stock_quantity, :shipping_fees, :tax, numericality: { greater_than: 0 }
  has_many_attached :images, dependent: :destroy
  belongs_to :category
  belongs_to :subcategory
  has_many :orders, dependent: :destroy 
  belongs_to :user, optional: true #, class_name: "merchant", foreign_key: "merchant_id"

  has_many :wishlist_products
  has_many :wishlists, through: :wishlist_products

  has_many :cart_items
  has_many :carts, through: :cart_items
end
