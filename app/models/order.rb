class Order < ApplicationRecord
  paginates_per 5
  max_paginates_per 3
  max_pages 3
  
  # validates_presence_of :order_quantity, :order_address
  # validates :order_quantity, numericality: { greater_than: 0 }
  # validate :is_stock_available?
  # validates_acceptance_of :read_terms
  # before_save :subtotal, :total
  
  # belongs_to :product
  belongs_to :user

  has_many :order_products , dependent: :destroy
  has_many :products, through: :order_products, dependent: :destroy
  # has_one :address, as: :addressable
  # has_many :cart_items
  # accepts_nested_attributes_for :address, allow_destroy: true, reject_if: :all_blank

  # before_save :subtotal, :total
  # after_create :create_payment
  # enum payment_method: %i[credit_card]

  # def subtotal
  #   subtotal = (self.product.price*self.order_quantity) + self.product.shipping_fees
  # end

  # def total
  #   total = self.subtotal + self.product.tax
  # end

  def is_stock_available?
    return unless self.order_quantity.present?

    unless self.order_quantity <= self.product.stock_quantity
      errors.add(:order_quantity, "is more than the stock available.")
    end
  end
end