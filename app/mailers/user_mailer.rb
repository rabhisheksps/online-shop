class UserMailer < Devise::Mailer

  def order_placed(order, product, charge)
    @product = product
    @order = order
    @charge = charge
    mail(to: @order.user.email, from: 'abhishek_rastogi@softprodigy.com', subject: "Your ekart order has been placed.")
  end
end
