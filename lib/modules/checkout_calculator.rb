module CheckoutCalculator
  def checkout_total(cart_items)
    total_amount = 0
    cart_items.each do |cart_item|
      product = cart_item.product
      amount = (product.price * cart_item.cart_item_quantity) + product.tax + product.shipping_fees
      total_amount += amount
    end
    return total_amount
  end
end