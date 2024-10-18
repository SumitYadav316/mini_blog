class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  before_action :set_comment, only: [:edit, :update, :destroy]

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      # CommentNotificationJob.perform_later(@post, @comment)

      redirect_to post_path(@post), notice: 'Comment was successfully created.'
    else
      redirect_to post_path(@post), alert: 'Error creating comment.'
    end
  end

  def edit
    redirect_to post_path(@post), alert: 'You are not authorized to edit this comment.' unless @comment.user == current_user
  end

  def update
    if @comment.update(comment_params)
      redirect_to post_path(@post), notice: 'Comment was successfully updated.'
    else
      redirect_to post_path(@post), alert: 'Error updating comment.'
    end
  end

  def destroy
    @comment.destroy
    redirect_to post_path(@post), notice: 'Comment was successfully deleted.'
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
