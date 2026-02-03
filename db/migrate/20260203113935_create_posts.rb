class CreatePosts < ActiveRecord::Migration[8.1]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.string :media_url, null: false
      t.string :media_type, null: false
      t.string :cloudinary_public_id
      t.integer :upvotes_count, default: 0
      t.integer :downvotes_count, default: 0
      t.integer :comments_count, default: 0
      t.integer :score, default: 0

      t.timestamps
    end

    add_index :posts, :score
    add_index :posts, [:created_at, :score]
  end
end
