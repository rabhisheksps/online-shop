class CreateCardInfos < ActiveRecord::Migration[7.0]
  def change
    create_table :card_infos do |t|
      t.string :brand
      t.string :country
      t.integer :last4
      t.integer :exp_month
      t.integer :exp_year
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end