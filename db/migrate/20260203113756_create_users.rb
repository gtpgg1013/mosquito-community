class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :clerk_user_id
      t.string :email
      t.string :username
      t.string :display_name
      t.string :avatar_url
      t.text :bio
      t.integer :total_score, default: 0

      t.timestamps
    end
    add_index :users, :clerk_user_id, unique: true
    add_index :users, :email, unique: true
    add_index :users, :username, unique: true
  end
end
