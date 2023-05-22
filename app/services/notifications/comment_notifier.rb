# frozen_string_literal: true

module Notifications
  class CommentNotifier
    def initialize(actor, comment)
      @actor = actor
      @comment = comment
    end

    def notify
      return if user == actor

      Notification.find_or_create_by(
        content: content,
        user: user,
        target: comment,
        actor: actor,
      )
    end

    private

    attr_reader :comment, :actor

    def content
      "commented on your post."
    end

    def user
      @user ||= comment.post.user
    end
  end
end
