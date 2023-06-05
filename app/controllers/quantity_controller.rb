class QuantityController < ApplicationController
  def increase
    @product = Product.find(params[:product_id])
    @product.increment!(:quantity)
    broadcast_product_quantity
  end

  def decrease
    @product = Product.find(params[:product_id])
    @product.decrement!(:quantity)
    broadcast_product_quantity
  end

  private

  def broadcast_product_quantity
    Turbo::StreamsChannel.broadcast_replace_to("product-quantity", partial: 'carts/quantity', locals: { product: @product })
  end
end
