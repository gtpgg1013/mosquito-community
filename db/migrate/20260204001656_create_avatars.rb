class CreateAvatars < ActiveRecord::Migration[8.1]
  def change
    create_table :avatars do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.references :head_item, foreign_key: { to_table: :avatar_items }
      t.references :body_item, foreign_key: { to_table: :avatar_items }
      t.references :background_item, foreign_key: { to_table: :avatar_items }
      t.references :accessory_item, foreign_key: { to_table: :avatar_items }

      t.timestamps
    end
  end
end
