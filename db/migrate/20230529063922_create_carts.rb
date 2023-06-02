class CreateCarts < ActiveRecord::Migration[7.0]
  def change
    create_table :carts do |t|
      t.string :payment_status
      t.float :subtotal
      t.float :total
      t.boolean :approval_status, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
