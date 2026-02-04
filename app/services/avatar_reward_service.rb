class AvatarRewardService
  REWARDS = {
    first_post: {
      description: "첫 게시물 작성",
      items: ["기본 모자", "기본 티셔츠", "기본 배경", "파리채"]
    },
    posts_5: {
      description: "게시물 5개 달성",
      items: ["모기 뿔 머리띠"]
    },
    posts_10: {
      description: "게시물 10개 달성",
      items: ["모기 퇴치 조끼", "모기향"]
    },
    posts_25: {
      description: "게시물 25개 달성",
      items: ["헌터 헬멧", "전기 파리채"]
    },
    posts_50: {
      description: "게시물 50개 달성",
      items: ["위장 유니폼", "습지대"]
    },
    posts_100: {
      description: "게시물 100개 달성",
      items: ["전기 파리채 왕관", "네온 아머"]
    },
    comments_10: {
      description: "댓글 10개 달성",
      items: ["여름 밤"]
    },
    comments_50: {
      description: "댓글 50개 달성",
      items: ["모기장 모자", "모기 스프레이"]
    },
    votes_received_50: {
      description: "받은 투표 50개 달성",
      items: ["정글"]
    },
    votes_received_100: {
      description: "받은 투표 100개 달성",
      items: ["방호복", "레이저 포인터"]
    },
    votes_received_500: {
      description: "받은 투표 500개 달성",
      items: ["네온 시티", "모기 탐지 드론"]
    },
    ranking_top_1: {
      description: "랭킹 1위 달성",
      items: ["황금 모기 왕관", "레전더리 헌터 슈트", "우주 정거장", "플라즈마 블레이드"]
    }
  }.freeze

  def initialize(user)
    @user = user
  end

  def check_and_grant_rewards
    granted = []

    REWARDS.each do |reward_key, reward_data|
      next unless eligible?(reward_key)
      next if already_granted?(reward_key)

      items = grant_reward(reward_key, reward_data[:items])
      granted << { key: reward_key, description: reward_data[:description], items: items } if items.any?
    end

    granted
  end

  def grant_starter_items
    return if @user.avatar_items.any?

    starter_items = ["기본 모자", "기본 티셔츠", "기본 배경", "파리채"]
    granted = []

    starter_items.each do |item_name|
      item = AvatarItem.find_by(name: item_name)
      next unless item
      next if @user.owns_item?(item)

      @user.acquire_item!(item)
      granted << item
    end

    granted
  end

  private

  def eligible?(reward_key)
    case reward_key
    when :first_post
      @user.posts.count >= 1
    when :posts_5
      @user.posts.count >= 5
    when :posts_10
      @user.posts.count >= 10
    when :posts_25
      @user.posts.count >= 25
    when :posts_50
      @user.posts.count >= 50
    when :posts_100
      @user.posts.count >= 100
    when :comments_10
      @user.comments.count >= 10
    when :comments_50
      @user.comments.count >= 50
    when :votes_received_50
      total_votes_received >= 50
    when :votes_received_100
      total_votes_received >= 100
    when :votes_received_500
      total_votes_received >= 500
    when :ranking_top_1
      achieved_top_1?
    else
      false
    end
  end

  def already_granted?(reward_key)
    items = REWARDS[reward_key][:items]
    return false if items.empty?

    # Check if user already has ALL items from this reward
    items.all? do |item_name|
      item = AvatarItem.find_by(name: item_name)
      item && @user.owns_item?(item)
    end
  end

  def grant_reward(reward_key, item_names)
    granted = []

    item_names.each do |item_name|
      item = AvatarItem.find_by(name: item_name)
      next unless item
      next if @user.owns_item?(item)

      @user.acquire_item!(item)
      granted << item
    end

    granted
  end

  def total_votes_received
    Vote.joins(:post).where(posts: { user_id: @user.id }).count
  end

  def achieved_top_1?
    # Check if user has ever been #1 in any ranking period
    # This would require a ranking history table, for now check current
    top_post = Post.order(score: :desc).first
    top_post&.user_id == @user.id
  end
end
