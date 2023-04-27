# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.includes(:followers, :following).find_by(id: params[:id])
    @pagy, @posts = pagy(@user.posts.includes(:likes, :likers, :comments).order(created_at: :desc), items: 10)
  end
end
