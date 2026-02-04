class Avatar < ApplicationRecord
  belongs_to :user
  belongs_to :head_item, class_name: 'AvatarItem', optional: true
  belongs_to :body_item, class_name: 'AvatarItem', optional: true
  belongs_to :background_item, class_name: 'AvatarItem', optional: true
  belongs_to :accessory_item, class_name: 'AvatarItem', optional: true

  validates :user_id, uniqueness: true

  def equip(item)
    return false unless user.owns_item?(item)

    case item.category
    when 'head' then update(head_item: item)
    when 'body' then update(body_item: item)
    when 'background' then update(background_item: item)
    when 'accessory' then update(accessory_item: item)
    else false
    end
  end

  def unequip(category)
    case category
    when 'head' then update(head_item: nil)
    when 'body' then update(body_item: nil)
    when 'background' then update(background_item: nil)
    when 'accessory' then update(accessory_item: nil)
    else false
    end
  end

  def equipped_items
    [head_item, body_item, background_item, accessory_item].compact
  end

  def equipped?(item)
    equipped_items.include?(item)
  end
end
