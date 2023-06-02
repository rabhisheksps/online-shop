class CartsController < ApplicationController

  def index
    @cart = current_user.cart
    @cart_items = current_user.cart.cart_items.includes(product: [images_attachments: :blob])
  end

  def new
    @cart = Cart.new
    @product = Product.find(params[:product_id])
  end

  def create
    if !current_user.cart.present?
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

  # def show
  #   @cart = current_user.cart
  #   @cart_items = @cart.cart_items.products
  # end

  def add_item
    @cart = current_user.cart
    @product = Product.find(params[:product_id])
    @cart.cart_items.create(cart_id: @cart.id, product_id: @product.id, cart_item_quantity: 1)
    redirect_to carts_path, notice: "Product added to cart successfully"
  end

  def update
    @cart_item = current_user.cart.cart_items.find(params[:id])
    @cart_item.product.update(product_order_quantity: params[:product_order_quantity])
    respond_to do |format|
      format.js
    end
  end

  # def remove_item
  #   @cart_item = current_user.cart.cart_items.find(params[:cart_item_id])
  #   @cart_item.destroy
  #   redirect_to cart_path
  # end

  # def increase_count
  #   @cart_item = current_user.cart.cart_items.find(params[:id])
  #   @cart_item.product.increment!(:product_order_quantity)

  #   respond_to do |format|
  #     format.js
  #   end
  # end
end
