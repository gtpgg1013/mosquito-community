class UserAvatarItem < ApplicationRecord
  belongs_to :user
  belongs_to :avatar_item

  validates :user_id, uniqueness: { scope: :avatar_item_id, message: "already owns this item" }

  scope :recent, -> { order(acquired_at: :desc) }
  scope :by_category, ->(category) { joins(:avatar_item).where(avatar_items: { category: category }) }
end
