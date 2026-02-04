class CreateUserAvatarItems < ActiveRecord::Migration[8.1]
  def change
    create_table :user_avatar_items do |t|
      t.references :user, null: false, foreign_key: true
      t.references :avatar_item, null: false, foreign_key: true
      t.datetime :acquired_at, default: -> { 'CURRENT_TIMESTAMP' }

      t.timestamps
    end

    add_index :user_avatar_items, [:user_id, :avatar_item_id], unique: true
  end
end
