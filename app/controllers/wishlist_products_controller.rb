class WishlistProductsController < ApplicationController
  def index
    @wishlist_products = current_user.wishlist_products.includes(:product).page(params[:page])
  end

  def new
  end

  def create
    # @favorite_item = current_user.favorite.new(favorite_params.merge(product_id: params[:product_id]))
    # current_user.favorite.create(product_id: @product.id, user_id: current_user.id)
    # if @favorite_item.save
    #   redirect_to products_path, notice: "Product successfully added to your favorite!." 
    # else
    #   redirect_to root_path, status: :unprocessable_entity 
    # end

    # @product = Product.find(params[:product_id])
    # @product.update(item_favorite: true)
    # @favorite_item = WishlistProducts.new
    # if @favorite_item.save
    #   redirect_to @favorite_item, notice: "Product successfully added to your favorite!"
    # else
    #   redirect_to root_path, notice: "Product cannot be added to your favorite!"
    # end
  end

  def show
    @wishlist_product = WishlistProduct.find(params[:id])
  end

  def destroy
    @wishlist_product = current_user.wishlist_products.find(params[:id])
    @wishlist_product.delete
    redirect_to wishlist_products_path, notice: 'Product removed from favorite!'
  end
end