class Subcategory < ApplicationRecord

  # enum :subcategory_name, {Tshirts: 'Tshirts', Shirts: 'Shirts',
    #  Jeans: 'Jeans', Footwear: 'Footwear', Caps: 'Caps', Electronics: 'Electronics'}

  belongs_to :category
  has_many :products
  has_one_attached :image, dependent: :destroy
end
