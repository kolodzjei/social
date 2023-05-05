# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.includes(:followers, :following).find_by(id: params[:id])
    @pagy, @posts = pagy(@user.posts.includes(:likes, :likers, :comments).order(created_at: :desc), items: 10)
  end

  def followers
    @user = User.includes(:followers).find_by(id: params[:id])
    @pagy, @followers = pagy(@user.followers, items: 10)

    respond_to do |format|
      format.html { render(:followers) }
    end
  end

  def following
    @user = User.includes(:following).find_by(id: params[:id])
    @pagy, @following = pagy(@user.following, items: 10)

    respond_to do |format|
      format.html { render(:following) }
    end
  end
end
