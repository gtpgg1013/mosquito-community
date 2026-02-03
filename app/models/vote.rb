class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :value, presence: true, inclusion: { in: [-1, 1] }
  validates :user_id, uniqueness: { scope: :post_id }

  after_save :update_post_counts
  after_destroy :update_post_counts

  private

  def update_post_counts
    post.update!(
      upvotes_count: post.votes.where(value: 1).count,
      downvotes_count: post.votes.where(value: -1).count
    )
    post.update_score!
  end
end
