class Category < ApplicationRecord

  # enum :category_name, {Men: 'Men', Women: 'Women', Children: 'Children'}
  # paginates_per 5
  # max_paginates_per 3
  # max_pages 3
  
  has_many :subcategories
  has_many :products
  has_one_attached :image, dependent: :destroy
end
