# frozen_string_literal: true

class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:create, :destroy]

  def create
    current_user.follow(@user)
    update_relationship_partial
  end

  def destroy
    current_user.unfollow(@user)
    update_relationship_partial
  end

  private

  def set_user
    @user = User.find_by(id: params[:user_id])
    unless @user
      flash[:alert] = "Unable to find user with id #{params[:user_id]}"
      redirect_back(fallback_location: root_path)
    end
  end

  def update_relationship_partial
    render(turbo_stream:
      turbo_stream.replace(
        "follow",
        partial: "relationships/relationship",
        locals: { user: @user },
      ))
  end
end
