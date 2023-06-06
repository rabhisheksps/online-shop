class WishlistsController < ApplicationController
  def index
    @favorite_items = current_user.wishlist_products.order('created_at DESC')
  end

  def new
  end

  def create
  end
end