class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :nfts, dependent: :destroy
  has_one :avatar, dependent: :destroy
  has_many :user_avatar_items, dependent: :destroy
  has_many :avatar_items, through: :user_avatar_items

  # Validations
  validates :clerk_user_id, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :username, uniqueness: true, allow_nil: true

  # Find or create user from Clerk data
  def self.from_clerk(clerk_user)
    find_or_create_by(clerk_user_id: clerk_user["id"]) do |user|
      user.email = clerk_user.dig("email_addresses", 0, "email_address")
      user.display_name = [clerk_user["first_name"], clerk_user["last_name"]].compact.join(" ")
      user.avatar_url = clerk_user["image_url"]
    end
  end

  # Avatar methods
  def owns_item?(item)
    avatar_items.include?(item)
  end

  def acquire_item!(item)
    user_avatar_items.find_or_create_by(avatar_item: item)
  end

  def owned_items_by_category(category)
    avatar_items.by_category(category)
  end

  def ensure_avatar!
    avatar || create_avatar!
  end
end
