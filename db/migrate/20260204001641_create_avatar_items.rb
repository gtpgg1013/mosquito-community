class CreateAvatarItems < ActiveRecord::Migration[8.1]
  def change
    create_table :avatar_items do |t|
      t.string :name, null: false
      t.string :category, null: false
      t.string :rarity, null: false, default: 'common'
      t.text :description
      t.string :image_url
      t.integer :price, default: 0

      t.timestamps
    end

    add_index :avatar_items, :category
    add_index :avatar_items, :rarity
  end
end
