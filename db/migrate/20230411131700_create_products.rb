class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :product_name
      t.float :price
      t.string :material
      t.string :vendor
      t.text :description
      t.integer :stock_quantity
      t.string :approval_status, default: "Not Set"
      t.decimal :shipping_fees,precision: 10, scale: 2
      t.decimal :tax, precision: 10, scale: 2
      t.references :user, null: true, foreign_key: true
      
      t.timestamps
    end
  end
end
