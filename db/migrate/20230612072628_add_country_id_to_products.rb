class AddCountryIdToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :country_id, :integer, optional: true
  end
end
