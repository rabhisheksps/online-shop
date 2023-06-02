class AddColumnToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :category_id, :integer
    add_column :products, :subcategory_id, :integer
    add_column :products, :available, :boolean
  end
end
