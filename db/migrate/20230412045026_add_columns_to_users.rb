class AddColumnsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :dob, :date
    add_column :users, :phone_number, :string
    add_column :users, :role, :string
    add_column :users, :stripe_id, :string
    add_column :users, :approval_status, :string, default: "Not Set"
  end
end
