class AddEmojiToAvatarItems < ActiveRecord::Migration[8.1]
  def change
    add_column :avatar_items, :emoji, :string
  end
end
