class Webhooks::PaymentsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def create
    event_id = params[:id]
    event = Stripe::Event.retrieve(
      event_id
    )
    case event.type
    when 'checkout.session.async_payment_failed'
      redirect_to '/' , notice: "Payment failed. Please try again."
    when 'checkout.session.completed'
      user_id = event.data.object.metadata.user_id
      payment_intent_value = event.data.object.payment_intent # contains a Stripe::PaymentMethod
      user = User.find(user_id)
      cart_items = user.cart_items
      order = user.orders.create
      cart_items.each do |item|
        present_stock_quantity = item.product.stock_quantity - item.cart_item_quantity
        item.product.update!(stock_quantity: present_stock_quantity)
        order.order_products.create!(product_id: item.product.id)
        order.save
      end

      order.order_products.each do |order_product|
        order_product.update(taxation_id: payment_intent_value)
      end
  
      cart = user.cart
      cart.update(payment_status: 'Paid')
      cart.cart_items.destroy_all
      puts "Payment #{event.data.object[:amount_total]} succeeded."
    when 'checkout.session.expired'
      redirect_to '/' , notice: "Payment failed. Please try again."
      puts 'Payment Link expired!'
    else
      puts "Unhandled event type: #{event.type}"
    end
  end
end