class WishlistProductsController < ApplicationController
  def index
    @wishlist_products = current_user.wishlist_products.page(params[:page])
  end

  def new
  end

  def create
  end

  def show
    @wishlist_product = Product.find(params[:id])
  end

  def destroy
    @wishlist_product = current_user.wishlist_products.find(params[:id])
    @wishlist_product.destroy
    redirect_to wishlist_products_path, notice: 'Product removed from favorite!'
  end
end