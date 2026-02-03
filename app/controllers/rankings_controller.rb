class RankingsController < ApplicationController
  def index
    @period = params[:period] || "daily"

    @posts = case @period
    when "weekly"
      Post.this_week
    when "monthly"
      Post.this_month
    else # daily
      Post.today
    end

    @posts = @posts.includes(:user).by_score.limit(50)
  end
end
