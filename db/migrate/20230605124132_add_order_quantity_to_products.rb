class AddOrderQuantityToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :final_order_quantity, :integer, default: 0
  end
end
