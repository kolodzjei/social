# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @pagy, @posts = pagy(Post.includes(:likes, :likers, :comments, :user).order(created_at: :desc), items: 10)
    @post = Post.new
    @following = current_user.following.limit(5)
  end
end
