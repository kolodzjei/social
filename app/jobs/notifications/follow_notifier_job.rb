# frozen_string_literal: true

module Notifications
  class FollowNotifierJob
    include Sidekiq::Job

    def perform(args)
      following = User.find_by(id: args["following_id"])
      followed = User.find_by(id: args["followed_id"])
      return unless following && followed

      Notifications::FollowNotifier.new(following, followed).notify
    end
  end
end
