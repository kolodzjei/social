# frozen_string_literal: true

class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:create, :destroy]

  def create
    current_user.follow(@user)
    send_notification
    respond_to do |format|
      format.html { redirect_back(fallback_location: user_path(@user)) }
      format.turbo_stream
    end
  end

  def destroy
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_back(fallback_location: user_path(@user)) }
      format.turbo_stream
    end
  end

  private

  def set_user
    @user = User.find_by(id: params[:user_id])
    unless @user
      flash[:alert] = "Unable to find user with id #{params[:user_id]}"
      redirect_back(fallback_location: root_path)
    end
  end

  def send_notification
    Notifications::FollowNotifier.new(current_user, @user).notify
  end
end
