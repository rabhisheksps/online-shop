class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable

  after_create :create_stripe_customer, :create_cart, :create_wishlist

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  validates_presence_of :first_name, :last_name, :phone_number, :role
  validates_uniqueness_of :email, :phone_number
  enum :role, {Customer: 'Customer', Merchant: 'Merchant'}

  has_one_attached :profile_picture, dependent: :destroy

  has_many :addresses
  has_many :products, dependent: :destroy
  has_many :orders , dependent: :destroy

  has_one :wishlist, dependent: :destroy
  has_many :wishlist_products, through: :wishlist
  has_many :products_of_wishlist, through: :wishlist, source: :products

  has_one :cart, dependent: :destroy
  has_one :card_info
  has_many :cart_items, through: :cart

  def create_stripe_customer    
    customer = Stripe::Customer.create(email: email)
    self.update(stripe_id: customer.id)
  end
 
  # def self.from_omniauth(auth)
  #   where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
  #     user.email = auth.info.email
  #     user.password = Devise.friendly_token [0, 20]
  #     user.full_name = auth.info.first_name   #assuming the user model has a name
  #     user.avatar_url = auth.info.image #assuming the user model has an image
  #   end
  # end

  def create_cart
    self.cart = Cart.create(user_id: self.id)
    cart.update(payment_status: "Unpaid")
  end

  def create_wishlist
    self.wishlist = Wishlist.create(user_id: self.id)
  end
end
