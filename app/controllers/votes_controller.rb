class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @vote = @post.votes.find_by(user: current_user)

    if @vote
      if @vote.value == vote_value
        # Same vote - remove it (toggle off)
        @vote.destroy
      else
        # Different vote - update it
        @vote.update(value: vote_value)
      end
    else
      # New vote
      @post.votes.create(user: current_user, value: vote_value)
    end

    @post.reload

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "vote-buttons-#{@post.id}",
          partial: "votes/vote_buttons",
          locals: { post: @post }
        )
      end
      format.html { redirect_to @post }
    end
  end

  def destroy
    @vote = @post.votes.find_by(user: current_user)
    @vote&.destroy
    @post.reload

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "vote-buttons-#{@post.id}",
          partial: "votes/vote_buttons",
          locals: { post: @post }
        )
      end
      format.html { redirect_to @post }
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def vote_value
    params[:value].to_i == 1 ? 1 : -1
  end
end
