class Webhooks::PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:update_status]
  # def update_resource(resource, params)
  #   if resource.provider == 'google_oauth2'
  #     params.delete('current_password')
  #     resource.password = params['password']
  #     resource.update_without_password(params)
  #   else
  #     resource.update_with_password(params)
  #   end
  # end

  def update_status
    render json: {message: "Payment Status Update"}
    # if[params[:status] == 'complete']
    #   current_user.cart.update(payment_status: 'Paid')
    #   current_user.cart.cart_items.destroy_all
    #   redirect_to orders_path, notice: "Payment done successfully."
    # else
    #   redirect_to carts_path, notice: "Payment failed. Please try again."
    # end
  end
end