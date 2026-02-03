class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  before_action :set_comment, only: [:destroy]

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.prepend("comments", partial: "comments/comment", locals: { comment: @comment }),
            turbo_stream.replace("new_comment", partial: "comments/form", locals: { post: @post, comment: Comment.new })
          ]
        end
        format.html { redirect_to @post, notice: "댓글이 작성되었습니다." }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "new_comment",
            partial: "comments/form",
            locals: { post: @post, comment: @comment }
          )
        end
        format.html { redirect_to @post, alert: @comment.errors.full_messages.join(", ") }
      end
    end
  end

  def destroy
    if @comment.user == current_user
      @comment.destroy
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.remove(@comment) }
        format.html { redirect_to @post, notice: "댓글이 삭제되었습니다." }
      end
    else
      redirect_to @post, alert: "권한이 없습니다."
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
