class WishlistsController < ApplicationController
  def index
    @favorite_items = current_user.wishlist_products.order('created_at DESC')
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

  def destroy
    @favorite_item = Wishlist.find(params[:product_id])
    @favorite_item.destroy
    redirect_to root_path, notice: 'Product removed from favorite!'
  end

  # def remove_from_wishlist
  #   @product = Product.find(params[:id])
  #   @product.destroy
  #   redirect_to root_path, notice: "Product successfully removed from your wishlist!"
  # end
end