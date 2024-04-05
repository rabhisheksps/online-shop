class CartItemsController < ApplicationController
  def destroy
    @cart_item = current_user.cart_items.find(params[:id])
    @cart_item.destroy
    redirect_to carts_path, notice: "Item added in the cart has been removed successfully."
  end
end
