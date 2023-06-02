class OrdersController < ApplicationController

  before_action :authenticate_user!
  before_action :find_order, except: %i[index new create destroy]

  def index
    @cart = current_user.cart
    @paid_cart_items = @cart.cart_items
  end

  def new
    @order = Order.new
    @product = Product.find(params[:product_id])
  end

  def create
    @order = current_user.orders.new(order_params.merge(product_id: params[:product_id]))
    if @order.save
      redirect_to order_checkout_path(@order.id)
    else
      @product = Product.find(params[:product_id])
      flash[:alert] = @order.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @order.update!(order_params)
      redirect_to orders_path, notice: "Order information is updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @order = current_user.orders.find(params[:id]) 
    if @order.destroy!
      redirect_to orders_path, notice: "Your order has been successfully cancelled."
    else
      redirect_to products_path, notice: "Your order cannot be cancelled. Try Again!"
    end
  end

  # def charge
  #   customer = Stripe::Customer.create(
  #     email: params[:stripeEmail],
  #     source: params[:stripeToken]
  #   )
  
  #   charge = Stripe::Charge.create(
  #     customer: customer.id,
  #     amount: params[:amount],
  #     description: 'Rails Stripe customer',
  #     currency: params[:currency]
  #   )
  
  #   rescue Stripe::CardError => e
  #     flash[:error] = e.message
  #     redirect_to new_charge_path
  # end

  private

  def order_params
    params.require(:order).permit(:order_quantity, :order_address, :pincode, 
      :city, :state, :country, :read_terms)
  end

  def find_order
    @order = Order.find(params[:id])
  end
end