# frozen_string_literal: true

module Comments
  class LikesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_comment

    def create
      @comment.like(current_user)
      send_notification
      update_likes_form
    end

    def destroy
      @comment.unlike(current_user)
      update_likes_form
    end

    private

    def set_comment
      @comment = Comment.find_by(id: params[:comment_id])

      unless @comment
        flash[:alert] = "Comment not found."
        redirect_to(root_path)
      end
    end

    def send_notification
      Notifications::LikeNotifierJob.perform_async({
        likeable_type: "Comment",
        likeable_id: @comment.id,
        user_id: current_user.id,
      }.stringify_keys)
    end

    def update_likes_form
      render(turbo_stream:
        turbo_stream.replace(
          "comment_#{params[:comment_id]}-likes",
          partial: "likes/like_form",
          locals: { model: @comment },
        ))
    end
  end
end
