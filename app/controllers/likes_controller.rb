# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_likeable

  def create
    @likeable.like(current_user)
    update_likes_form
  end

  def destroy
    @likeable.unlike(current_user)
    update_likes_form
  end

  private

  def find_likeable
    @likeable = params[:likeable_type].classify.constantize.find(params[:likeable_id])
  end

  def update_likes_form
    render(turbo_stream:
      turbo_stream.replace(
        "post_#{params[:likeable_id]}-likes",
        partial: "likes/like_form",
        locals: { model: @likeable },
      ))
  end
end
