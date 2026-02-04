class NftsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @nfts = Nft.minted.includes(:post, :user).by_recent.page(params[:page]).per(12)
    @total_minted = Nft.minted.count
  end

  def show
    @nft = Nft.find(params[:id])
    @post = @nft.post
  end

  def create
    @post = Post.find(params[:post_id])
    
    unless Nft.eligible_for_minting?(@post)
      redirect_to @post, alert: "이 게시물은 NFT 발행 조건(10점 이상)을 충족하지 않습니다."
      return
    end

    unless @post.user == current_user
      redirect_to @post, alert: "본인의 게시물만 NFT로 발행할 수 있습니다."
      return
    end

    existing_nft = Nft.find_by(post: @post, user: current_user)
    if existing_nft
      redirect_to @post, alert: "이미 NFT가 발행된 게시물입니다."
      return
    end

    @nft = Nft.new(
      post: @post,
      user: current_user,
      network: 'polygon'
    )

    if @nft.save
      # Trigger minting in background (for demo, we do it synchronously)
      @nft.mint!
      redirect_to @nft, notice: "NFT가 성공적으로 발행되었습니다!"
    else
      redirect_to @post, alert: "NFT 발행에 실패했습니다."
    end
  end

  def my_nfts
    @nfts = current_user.nfts.includes(:post).by_recent
  end
end
