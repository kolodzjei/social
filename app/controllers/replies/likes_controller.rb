# frozen_string_literal: true

module Replies
  class LikesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_reply

    def create
      @reply.like(current_user)
      send_notification
      update_likes_form
    end

    def destroy
      @reply.unlike(current_user)
      update_likes_form
    end

    private

    def set_reply
      @reply = Reply.find_by(id: params[:reply_id])

      unless @reply
        flash[:alert] = "Reply not found."
        redirect_to(root_path)
      end
    end

    def send_notification
      Notifications::LikeNotifier.new(current_user, @reply).notify
    end

    def update_likes_form
      render(turbo_stream:
        turbo_stream.replace(
          "reply_#{params[:reply_id]}-likes",
          partial: "likes/like_form",
          locals: { model: @reply },
        ))
    end
  end
end
