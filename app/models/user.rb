class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable

  after_create :create_stripe_customer, :create_cart, :create_wishlist

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  validates_presence_of :password, on: :create, length: {minimum:8, maximum:8}
  validate :password_regex
  validates_presence_of :first_name, :last_name, :email, :phone_number, :phone_number, :role
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

  private

  def password_regex
    return if password.blank? || password =~ /\A(?=.*\d)(?=.*[A-Z])(?=.*\W)[^ ]{7,}\z/
    errors.add :password,
               'should have more than 6 characters including 1 uppercase letter, 1 number, 1 special character'
  end

  def create_stripe_customer    
    customer = Stripe::Customer.create(email: email)
    self.update(stripe_id: customer.id)
  end

  def create_cart
    self.cart = Cart.create(user_id: self.id)
    cart.update(payment_status: "Unpaid")
  end

  def create_wishlist
    self.wishlist = Wishlist.create(user_id: self.id)
  end
end
