# frozen_string_literal: true

module Posts
  class LikesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_post

    def create
      @post.like(current_user)
      send_notification
      update_likes_form
    end

    def destroy
      @post.unlike(current_user)
      update_likes_form
    end

    private

    def set_post
      @post = Post.find_by(id: params[:post_id])

      unless @post
        flash[:alert] = "Post not found."
        redirect_to(root_path)
      end
    end

    def send_notification
      Notifications::LikeNotifier.new(current_user, @post).notify
    end

    def update_likes_form
      render(turbo_stream:
        turbo_stream.replace(
          "post_#{params[:post_id]}-likes",
          partial: "likes/like_form",
          locals: { model: @post },
        ))
    end
  end
end
