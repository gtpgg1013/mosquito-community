class AvatarsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_avatar, only: [:show, :edit, :update]
  before_action :grant_starter_items, only: [:show, :edit, :shop]

  def show
    @owned_items = current_user.avatar_items.group_by(&:category)
  end

  def edit
    @owned_items = current_user.avatar_items.group_by(&:category)
    @all_items = AvatarItem.all.group_by(&:category)
  end

  def update
    if @avatar.update(avatar_params)
      respond_to do |format|
        format.html { redirect_to avatar_path, notice: "아바타가 업데이트되었습니다!" }
        format.turbo_stream { flash.now[:notice] = "아바타가 업데이트되었습니다!" }
      end
    else
      @owned_items = current_user.avatar_items.group_by(&:category)
      @all_items = AvatarItem.all.group_by(&:category)
      render :edit, status: :unprocessable_entity
    end
  end

  def equip
    item = AvatarItem.find(params[:item_id])
    avatar = current_user.ensure_avatar!

    if current_user.owns_item?(item)
      avatar.equip(item)
      respond_to do |format|
        format.html { redirect_to edit_avatar_path, notice: "#{item.name} 장착!" }
        format.turbo_stream { flash.now[:notice] = "#{item.name} 장착!" }
      end
    else
      redirect_to edit_avatar_path, alert: "소유하지 않은 아이템입니다."
    end
  end

  def unequip
    avatar = current_user.ensure_avatar!
    category = params[:category]

    if AvatarItem::CATEGORIES.include?(category)
      avatar.unequip(category)
      respond_to do |format|
        format.html { redirect_to edit_avatar_path, notice: "#{category} 해제!" }
        format.turbo_stream { flash.now[:notice] = "#{category} 해제!" }
      end
    else
      redirect_to edit_avatar_path, alert: "잘못된 카테고리입니다."
    end
  end

  def inventory
    @owned_items = current_user.user_avatar_items.includes(:avatar_item).recent
    @items_by_category = current_user.avatar_items.group_by(&:category)
  end

  def shop
    @items = AvatarItem.all.group_by(&:category)
    @owned_item_ids = current_user.avatar_items.pluck(:id)
  end

  def buy
    item = AvatarItem.find(params[:item_id])

    if current_user.owns_item?(item)
      redirect_to shop_avatar_path, alert: "이미 소유한 아이템입니다."
      return
    end

    # TODO: 포인트 시스템 구현 후 차감 로직 추가
    current_user.acquire_item!(item)
    redirect_to shop_avatar_path, notice: "#{item.name} 구매 완료!"
  end

  private

  def set_avatar
    @avatar = current_user.ensure_avatar!
  end

  def grant_starter_items
    return if current_user.avatar_items.any?

    granted = AvatarRewardService.new(current_user).grant_starter_items
    if granted.any?
      flash.now[:notice] = "스타터 아이템 #{granted.count}개를 받았습니다!"
    end
  end

  def avatar_params
    params.require(:avatar).permit(:head_item_id, :body_item_id, :background_item_id, :accessory_item_id)
  end
end
