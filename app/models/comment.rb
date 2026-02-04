class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post, counter_cache: true

  validates :body, presence: true, length: { maximum: 1000 }

  after_create :check_avatar_rewards

  scope :by_recent, -> { order(created_at: :desc) }

  private

  def check_avatar_rewards
    AvatarRewardService.new(user).check_and_grant_rewards
  end
end
