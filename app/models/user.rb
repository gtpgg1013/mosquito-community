class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy

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
end
