# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @posts = Post.includes(:likes, :likers, :comments, :user).all
  end
end
