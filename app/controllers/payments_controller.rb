class PaymentsController < ApplicationController
  include Rails.application.routes.url_helpers
  def new
    order = Order.find(params[:order_id])
    @payment = Payment.new(order_id: params{:order.id})
  end

  def create
  end

  def checkout
    # @order = Order.find(params[:order_id])
    total_amount = 0
    product_names = []
    @cart = current_user.cart
    @cart_items = @cart.cart_items
    @cart_items.each do |cart_item|
      product = cart_item.product
      total_amount = (product.price * cart_item.cart_item_quantity) + product.tax + product.shipping_fees
      product_names << product.product_name
    end

    # card = customer.create_source(
    #   customer: customer.id,
    #   source: 'tok_visa'
    # )
    # customer.update(card_token: card.id)

    # puts get_order_images
    # debugger

    puts product_names.join(", ")

    stripe_product = Stripe::Product.create({
      name: product_names[0]
    })
    
    price = Stripe::Price.create({
      unit_amount: (total_amount*100).to_i,
      currency: 'usd',
      product: stripe_product.id,
    })
  
    # puts "************************************************************"
    # puts @product.shipping_fees
    # puts @product.tax
    # puts @product.price * @order.order_quantity
    # puts total_amount
    
    @session = Stripe::Checkout::Session.create(
      success_url: checkout_status_url + "?status=success",
      cancel_url: checkout_status_url + "?status=failed",
      customer_email: current_user.email,
      line_items: [{
        price: price.id,
        quantity: 1 #because stripe calculates it as one whole final amount
      }],
      # customer_details: [{
      #   address: {
      #     city: current_user.addresses.first.city,
      #     country: "IN",
      #     line1: current_user.addresses.first.address_line_1,
      #     line2: nil,
      #     postal_code: current_user.addresses.first.pincode,
      #     state: current_user.addresses.first.state
      #   }
      # }],
      mode: 'payment',
    )
    @session_id = @session.id
    redirect_to @session.url, allow_other_host: true
    # @cart.update(payment_status: "Paid")

    # charge = Stripe::Charge.create( customer: current_user.stripe_id,
    #   amount: price.unit_amount,
    #   currency: 'usd'
    # )

    # if charge["captured"]
    #   @order.update(payment_status: 'Paid')
    # end
    # redirect_to root_path, notice: 'Payment was successfully processed. Waiting for admin approval.'
  
  # rescue Stripe::CardError => e
  #   flash[:error] = e.message
  #   redirect_to root_path, notice: "Payment unsuccessful. Please try again!."
  end

  def checkout_status
    if params[:status] == 'success'

      debugger
      payment_session = Stripe::Checkout::Session.retrieve(@session_id)
      customer = Customer.find_or_initialize_by(stripe_customer_id: @session.customer)
      customer.email = session.customer_details.email
      puts customer

      # @cart = current_user.cart
      # @cart.update(payment_status: 'Paid')
      # @cart.cart_items.destroy_all
      redirect_to orders_path, notice: "Payment successfully made. Please wait for admin approval."
    else params[:status] == 'failed'
      redirect_to root_path, notice: "Payment failed. Please try again."
    end
  end

  # def success
  #   redirect_to orders_path, notice: "Payment successfully made. Please wait for admin approval."
  # end
  
  # def cancel
  #   redirect_to root_path, notice: "Payment failed. Please try again."
  # end

  private

  # def get_order_images
  #   images = []
  #   @product.images.map do |image|
  #     images << url_for(image)
  #   end if @product.images.present?
  #   images
  # end
end