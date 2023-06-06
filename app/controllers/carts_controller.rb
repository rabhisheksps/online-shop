class CartsController < ApplicationController

  before_action :authenticate_user!
  before_action :find_cart, except: %i[index new create change_quantity]

  def index
    @cart = current_user.cart
    @cart_items = current_user.cart.cart_items.includes(product: [images_attachments: :blob])
  end

  def new
    @cart = Cart.new
    @product = Product.find(params[:product_id])
  end

  def create
    if !@cart.present?
      @cart = Cart.create(user_id: current_user.id)
      if @cart.save
        redirect_to cart_checkout_path(@cart.id)
      else
        redirect_to root_path, notice: "Failed to add products to the cart!"
      end
    else
      @cart = current_user.cart
    end
  end

  def add_item
    @product = Product.find(params[:product_id])
    @cart.cart_items.create!(cart_id: @cart.id, product_id: @product.id, cart_item_quantity: 1)
    redirect_to carts_path, notice: "Product added to cart successfully"
  end

  def change_quantity
    @cart_item = current_user.cart_items.find(params[:id])
    if params[:change_type] == 'Increase'
      @cart_item.update(cart_item_quantity: @cart_item.cart_item_quantity + 1)
    elsif params[:change_type] == 'Decrease'
      @cart_item.update(cart_item_quantity: @cart_item.cart_item_quantity - 1)
      # product_total
    end
  end

  # def product_total
  #   @cart_item = current_user.cart_items.find(params[:id])
  # end

  private

  def find_cart
    @cart = current_user.cart
  end
end
