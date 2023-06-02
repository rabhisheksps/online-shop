class Address < ApplicationRecord
  paginates_per 5
  max_paginates_per 3
  max_pages 3
  
  belongs_to :user

  validates_presence_of :city, :state, :country, :pincode, :address_type
end
