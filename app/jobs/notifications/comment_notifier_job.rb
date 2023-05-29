# frozen_string_literal: true

module Notifications
  class CommentNotifierJob
    include Sidekiq::Job

    def perform(args)
      actor = User.find_by(id: args["actor_id"])
      comment = Comment.find_by(id: args["comment_id"])
      return unless actor && comment

      Notifications::CommentNotifier.new(actor, comment).notify
    end
  end
end
