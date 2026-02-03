class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post, counter_cache: true

  validates :body, presence: true, length: { maximum: 1000 }

  scope :by_recent, -> { order(created_at: :desc) }
end
