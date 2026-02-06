class AvatarItem < ApplicationRecord
  CATEGORIES = %w[head body background accessory].freeze
  RARITIES = %w[common rare epic legendary].freeze

  has_many :user_avatar_items, dependent: :destroy
  has_many :users, through: :user_avatar_items

  validates :name, presence: true
  validates :category, presence: true, inclusion: { in: CATEGORIES }
  validates :rarity, presence: true, inclusion: { in: RARITIES }
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  scope :by_category, ->(category) { where(category: category) }
  scope :by_rarity, ->(rarity) { where(rarity: rarity) }
  scope :heads, -> { by_category('head') }
  scope :bodies, -> { by_category('body') }
  scope :backgrounds, -> { by_category('background') }
  scope :accessories, -> { by_category('accessory') }

  def rarity_color
    case rarity
    when 'common' then 'gray'
    when 'rare' then 'blue'
    when 'epic' then 'purple'
    when 'legendary' then 'yellow'
    else 'gray'
    end
  end

  def rarity_emoji
    case rarity
    when 'common' then '⚪'
    when 'rare' then '🔵'
    when 'epic' then '🟣'
    when 'legendary' then '🌟'
    else '⚪'
    end
  end

  # 실제 아이템 이모지 (새 emoji 필드 사용)
  def display_emoji
    emoji.presence || default_emoji_for_category
  end

  private

  def default_emoji_for_category
    case category
    when 'head' then '🧢'
    when 'body' then '👕'
    when 'background' then '🌫️'
    when 'accessory' then '🪤'
    else '❓'
    end
  end
end
