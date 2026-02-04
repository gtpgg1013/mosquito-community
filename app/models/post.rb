class Post < ApplicationRecord
  belongs_to :user
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one :nft, dependent: :destroy

  validates :title, presence: true, length: { maximum: 100 }
  validates :media_url, presence: true
  validates :media_type, presence: true, inclusion: { in: %w[image video] }

  after_create :check_avatar_rewards

  scope :by_score, -> { order(score: :desc) }
  scope :by_recent, -> { order(created_at: :desc) }
  scope :today, -> { where("created_at >= ?", Time.current.beginning_of_day) }
  scope :this_week, -> { where("created_at >= ?", Time.current.beginning_of_week) }
  scope :this_month, -> { where("created_at >= ?", Time.current.beginning_of_month) }

  private

  def check_avatar_rewards
    AvatarRewardService.new(user).check_and_grant_rewards
  end

  def update_score!
    update!(score: upvotes_count - downvotes_count)
  end

  def image?
    media_type == "image"
  end

  def video?
    media_type == "video"
  end
end
