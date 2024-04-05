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
    puts total_amount

    stripe_product = Stripe::Product.create({
      name: 'Ordered Products'
    })
    
    price = Stripe::Price.create({
      unit_amount: (total_amount*100).to_i,
      currency: 'usd',
      product: stripe_product.id,
    })

    # CardInfo.create(user_id: current_user.id, brand: brand, country: country, exp_month: exp_month, exp_year: exp_year, last4: last4) if current_user.card_info.nil?
    
    @session = Stripe::Checkout::Session.create(
      success_url: success_url + "?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: cancel_url,
      customer_email: current_user.email,
      phone_number_collection: {enabled: false},
      line_items: [{
        price: price.id,
        quantity: 1 #because stripe calculates it as one whole final amount
      }],
      mode: 'payment',
      metadata: {
        user: current_user.id,
      },
    )
    redirect_to @session.url, allow_other_host: true
  end
  
  def success
    redirect_to orders_path, notice: "Payment successfully made. Thanks for choosing Ekart."
  end

  def cancel
    redirect_to '/', notice: "Payment failed. Visit your cart and please try again."
  end
end

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
    puts total_amount

    stripe_product = Stripe::Product.create({
      name: 'Ordered Products'
    })
    
    price = Stripe::Price.create({
      unit_amount: (total_amount*100).to_i,
      currency: 'usd',
      product: stripe_product.id,
    })

    # CardInfo.create(user_id: current_user.id, brand: brand, country: country, exp_month: exp_month, exp_year: exp_year, last4: last4) if current_user.card_info.nil?
    
    @session = Stripe::Checkout::Session.create(
      success_url: success_url + "?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: cancel_url,
      customer_email: current_user.email,
      phone_number_collection: {enabled: false},
      line_items: [{
        price: price.id,
        quantity: 1 #because stripe calculates it as one whole final amount
      }],
      mode: 'payment',
      metadata: {
        user_id: current_user.id,
      },
    )
    redirect_to @session.url, allow_other_host: true
  end
  
  def success
    redirect_to orders_path, notice: "Payment successfully made. Thanks for choosing Ekart."
  end

  def cancel
    redirect_to '/', notice: "Payment failed. Please try again."
  end
end