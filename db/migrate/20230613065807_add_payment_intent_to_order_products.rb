class AddPaymentIntentToOrderProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :order_products, :taxation_id, :string
  end
end
