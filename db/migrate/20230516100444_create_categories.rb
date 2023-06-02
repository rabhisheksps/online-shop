class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :category_name
      t.string :approval_status, default: "Not Set"

      t.timestamps
    end
  end
end
