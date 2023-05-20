# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_likeable

  def create
    @likeable.like(current_user)
    send_notification
    update_likes_form
  end

  def destroy
    @likeable.unlike(current_user)
    update_likes_form
  end

  private

  def find_likeable
    @likeable = params[:likeable_type].classify.constantize.find_by(id: params[:likeable_id])
    unless @likeable
      flash[:alert] = "Unable to find #{params[:likeable_type]} with id #{params[:likeable_id]}"
      redirect_to root_path
    end
  end

  def update_likes_form
    render(turbo_stream:
      turbo_stream.replace(
        "#{params[:likeable_type].downcase}_#{params[:likeable_id]}-likes",
        partial: "likes/like_form",
        locals: { model: @likeable },
      ))
  end

  def send_notification
    LikeNotifier.new(current_user, @likeable).notify
  end
end
