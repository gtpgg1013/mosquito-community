# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_02_04_074433) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "avatar_items", force: :cascade do |t|
    t.string "category", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "emoji"
    t.string "image_url"
    t.string "name", null: false
    t.integer "price", default: 0
    t.string "rarity", default: "common", null: false
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_avatar_items_on_category"
    t.index ["rarity"], name: "index_avatar_items_on_rarity"
  end

  create_table "avatars", force: :cascade do |t|
    t.bigint "accessory_item_id"
    t.bigint "background_item_id"
    t.bigint "body_item_id"
    t.datetime "created_at", null: false
    t.bigint "head_item_id"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["accessory_item_id"], name: "index_avatars_on_accessory_item_id"
    t.index ["background_item_id"], name: "index_avatars_on_background_item_id"
    t.index ["body_item_id"], name: "index_avatars_on_body_item_id"
    t.index ["head_item_id"], name: "index_avatars_on_head_item_id"
    t.index ["user_id"], name: "index_avatars_on_user_id", unique: true
  end

  create_table "comments", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.bigint "post_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "donations", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.string "currency", default: "USD", null: false
    t.datetime "donated_at", null: false
    t.text "notes"
    t.string "organization", null: false
    t.string "receipt_url"
    t.datetime "updated_at", null: false
    t.index ["donated_at"], name: "index_donations_on_donated_at"
    t.index ["organization"], name: "index_donations_on_organization"
  end

  create_table "nfts", force: :cascade do |t|
    t.string "contract_address"
    t.datetime "created_at", null: false
    t.string "metadata_url"
    t.datetime "minted_at"
    t.string "network", default: "polygon", null: false
    t.bigint "post_id", null: false
    t.string "status", default: "pending", null: false
    t.string "token_id"
    t.string "transaction_hash"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["post_id", "user_id"], name: "index_nfts_on_post_id_and_user_id", unique: true
    t.index ["post_id"], name: "index_nfts_on_post_id"
    t.index ["status"], name: "index_nfts_on_status"
    t.index ["token_id"], name: "index_nfts_on_token_id", unique: true
    t.index ["transaction_hash"], name: "index_nfts_on_transaction_hash"
    t.index ["user_id"], name: "index_nfts_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "cloudinary_public_id"
    t.integer "comments_count", default: 0
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "downvotes_count", default: 0
    t.string "media_type", null: false
    t.string "media_url", null: false
    t.integer "score", default: 0
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.integer "upvotes_count", default: 0
    t.bigint "user_id", null: false
    t.index ["created_at", "score"], name: "index_posts_on_created_at_and_score"
    t.index ["score"], name: "index_posts_on_score"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "user_avatar_items", force: :cascade do |t|
    t.datetime "acquired_at", default: -> { "CURRENT_TIMESTAMP" }
    t.bigint "avatar_item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["avatar_item_id"], name: "index_user_avatar_items_on_avatar_item_id"
    t.index ["user_id", "avatar_item_id"], name: "index_user_avatar_items_on_user_id_and_avatar_item_id", unique: true
    t.index ["user_id"], name: "index_user_avatar_items_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "avatar_url"
    t.text "bio"
    t.string "clerk_user_id"
    t.datetime "created_at", null: false
    t.string "display_name"
    t.string "email"
    t.integer "total_score", default: 0
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["clerk_user_id"], name: "index_users_on_clerk_user_id", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "post_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "value", null: false
    t.index ["post_id"], name: "index_votes_on_post_id"
    t.index ["user_id", "post_id"], name: "index_votes_on_user_id_and_post_id", unique: true
    t.index ["user_id"], name: "index_votes_on_user_id"
  end

  add_foreign_key "avatars", "avatar_items", column: "accessory_item_id"
  add_foreign_key "avatars", "avatar_items", column: "background_item_id"
  add_foreign_key "avatars", "avatar_items", column: "body_item_id"
  add_foreign_key "avatars", "avatar_items", column: "head_item_id"
  add_foreign_key "avatars", "users"
  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "nfts", "posts"
  add_foreign_key "nfts", "users"
  add_foreign_key "posts", "users"
  add_foreign_key "user_avatar_items", "avatar_items"
  add_foreign_key "user_avatar_items", "users"
  add_foreign_key "votes", "posts"
  add_foreign_key "votes", "users"
end
