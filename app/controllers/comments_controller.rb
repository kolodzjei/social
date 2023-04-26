# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!

  def show
    @comment = Comment.includes(:likers, :likes, :replies, :post).find_by(id: params[:id])
    @pagy, @replies = pagy(@comment.replies.includes(:user, :likers, :likes).order(created_at: :desc), items: 10)
    @reply = Reply.new
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user

    if @comment.save
      flash[:notice] = "Comment created"
    else
      flash[:alert] = "Something went wrong"
    end
    redirect_to(post_path(@comment.post))
  end

  def destroy
    @comment = Comment.find_by(id: params[:id])
    if @comment.user == current_user
      @comment.destroy
      flash[:notice] = "Comment deleted"
    else
      flash[:alert] = "Something went wrong"
    end
    redirect_to(post_path(@comment.post))
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :post_id)
  end
end
