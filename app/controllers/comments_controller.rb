# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!

  def show
    @comment = Comment.includes(:likers, :likes, :replies, :post, :rich_text_content).find_by(id: params[:id])
    return redirect_to(root_path) unless @comment

    @pagy, @replies = pagy(@comment.replies.not_reply.newest.includes(:user, :likers, :likes), items: 10)
    @reply = Reply.new
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user

    if @comment.save
      send_notification
      flash[:notice] = "Comment created"
    else
      flash[:alert] = "Something went wrong"
    end
    redirect_to(post_path(@comment.post))
  end

  def destroy
    @comment = Comment.find_by(id: params[:id])
    if @comment&.user == current_user
      @comment.destroy
      flash[:notice] = "Comment deleted"
      redirect_to(post_path(@comment.post))
    else
      flash[:alert] = "Something went wrong"
      redirect_to(root_path)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :post_id)
  end

  def send_notification
    Notifications::CommentNotifierJob.perform_async({ comment_id: @comment.id, actor_id: current_user.id }.stringify_keys)
  end
end
