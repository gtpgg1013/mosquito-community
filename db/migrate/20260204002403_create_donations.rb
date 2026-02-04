class CreateDonations < ActiveRecord::Migration[8.1]
  def change
    create_table :donations do |t|
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :currency, null: false, default: 'USD'
      t.string :organization, null: false
      t.datetime :donated_at, null: false
      t.text :notes
      t.string :receipt_url

      t.timestamps
    end

    add_index :donations, :donated_at
    add_index :donations, :organization
  end
end
