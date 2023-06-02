class CartItemsController < ApplicationController

  # def add_item
  #   @cart = current_user.cart
  #   @product = Product.find(params[:product_id])
  #   @cart.cart_items.create(cart_id: current_user.cart.id, product_id: @product.id)
  #   redirect_to root_path
  # end

  def destroy
    @cart_item = current_user.cart_items.find(params[:id])
    @cart_item.destroy
    redirect_to carts_path, notice: "Item added in the cart has been removed successfully."
  end
end
