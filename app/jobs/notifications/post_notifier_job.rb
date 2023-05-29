# frozen_string_literal: true

module Notifications
  class PostNotifierJob
    include Sidekiq::Job

    def perform(args)
      actor = User.find_by(id: args["actor_id"])
      post = Post.find_by(id: args["post_id"])
      return unless actor && post

      Notifications::PostNotifier.new(actor, post).notify
    end
  end
end
