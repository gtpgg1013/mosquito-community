class CreateNfts < ActiveRecord::Migration[8.1]
  def change
    create_table :nfts do |t|
      t.references :post, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :token_id
      t.string :contract_address
      t.string :transaction_hash
      t.string :metadata_url
      t.datetime :minted_at
      t.string :status, null: false, default: 'pending'
      t.string :network, null: false, default: 'polygon'

      t.timestamps
    end

    add_index :nfts, :token_id, unique: true
    add_index :nfts, :transaction_hash
    add_index :nfts, :status
    add_index :nfts, [:post_id, :user_id], unique: true
  end
end
