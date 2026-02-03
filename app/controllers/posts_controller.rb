class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    @posts = Post.includes(:user)
    @posts = params[:sort] == "score" ? @posts.by_score : @posts.by_recent
    @posts = @posts.page(params[:page]).per(12)
  end

  def show
    @comments = @post.comments.includes(:user).by_recent
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to @post, notice: "모기 퇴치 인증 완료! 🦟💀"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: "수정 완료!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "삭제 완료!"
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def authorize_user!
    unless @post.user == current_user
      redirect_to posts_path, alert: "권한이 없습니다."
    end
  end

  def post_params
    params.require(:post).permit(:title, :description, :media_url, :media_type, :thumbnail_url)
  end
end
