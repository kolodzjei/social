# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @pagy, @posts = pagy(Post.includes(:likes, :likers, :comments, :user).all, items: 10)
  end
end
