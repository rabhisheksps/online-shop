class PaymentsController < ApplicationController

  before_action :authenticate_user!, only: [:checkout, :new, :create, :success_url, :cancel_url]

  def new
    order = Order.find(params[:order_id])
    @payment = Payment.new(order_id: params{:order.id})
  end

  def create
  end

  def checkout
    total_amount = 0
    @product_names = []
    cart_items = current_user.cart_items.includes(:product)
    cart_items.each do |cart_item|
      product = cart_item.product
      if product.stock_quantity <= cart_item.cart_item_quantity
        flash[:notice] = "Order quantity must be less than available stock"
        return
      end
      amount = (product.price * cart_item.cart_item_quantity) + product.tax + product.shipping_fees
      total_amount += amount
      @product_names << product.product_name
    end

    # card = customer.create_source(
    #   customer: customer.id,
    #   source: 'tok_visa'
    # )
    # customer.update(card_token: card.id)

    puts @product_names.join(", ")
    puts @product_names.type
    puts total_amount

    stripe_product = Stripe::Product.create({
      name: @product_names
    })
    
    price = Stripe::Price.create({
      unit_amount: (total_amount*100).to_i,
      currency: 'usd',
      product: stripe_product.id,
    })

    # stripe_customer = Stripe::Customer.create_source(
    #   current_user.stripe_id,
    #   {source: 'tok_visa'},
    # )

    # brand = stripe_customer.brand
    # country = stripe_customer.country
    # exp_month = stripe_customer.exp_month
    # exp_year = stripe_customer.exp_year
    # last4 = stripe_customer.last4

    # debugger
    # CardInfo.create(user_id: current_user.id, brand: brand, country: country, exp_month: exp_month, exp_year: exp_year, last4: last4) if current_user.card_info.nil?
    
    session = Stripe::Checkout::Session.create(
      success_url: checkout_success_url,
      cancel_url: checkout_cancel_url,
      customer_email: current_user.email,
      phone_number_collection: {enabled: false},
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
    
    # session_id = session.id
    redirect_to(session.url, allow_other_host: true) and return

      # charge = Stripe::Charge.create( customer: current_user.stripe_id,
      #   amount: price.unit_amount,
      #   currency: 'usd'
      # )
      # if charge["captured"]
      #   @cart.update(payment_status: 'Paid')
      # end

    # puts charge.source.last4
    # redirect_to root_path, notice: 'Payment was successfully processed. Waiting for admin approval.'
  
    # rescue Stripe::CardError => e
    #   flash[:error] = e.message
    #   redirect_to root_path, notice: "Payment unsuccessful. Please try again!."
  end

  def checkout_success
    @cart_items = current_user.cart_items
    @order = current_user.orders.create
    @cart_items.each do |item|
      @order.order_products.create!(product_id: item.product.id)
      @order.save
    end

    @cart = current_user.cart
    @cart.update(payment_status: 'Paid')
    @cart.cart_items.destroy_all

    redirect_to orders_path, notice: "Payment successfully made. Thanks for choosing Ekart."
  end

  def checkout_cancel
    redirect_to '/' , notice: "Payment failed. Please try again."
  end
end