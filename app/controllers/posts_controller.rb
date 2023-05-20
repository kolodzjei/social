# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!

  def show
    @post = Post.includes(:likes, :likers, :user).find_by(id: params[:id])
    return redirect_to(root_path) unless @post

    @pagy, @comments = pagy(
      @post.comments.includes(:user, :likes, :likers, :replies).order(created_at: :desc),
      items: 10,
    )
    @comment = Comment.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user

    if @post.save
      send_notification
      flash[:notice] = "Post created"
    else
      flash[:alert] = "Something went wrong"
    end
    redirect_to(root_path)
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    if @post&.user == current_user
      @post.destroy
      flash[:notice] = "Post deleted"
    else
      flash[:alert] = "Something went wrong"
    end
    redirect_to(root_path)
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end

  def send_notification
    PostNotifier.new(current_user, @post).notify_followers
  end
end
