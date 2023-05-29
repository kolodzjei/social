# frozen_string_literal: true

module Notifications
  class LikeNotifierJob
    include Sidekiq::Job

    def perform(args)
      likeable_type = args["likeable_type"]
      likeable_id = args["likeable_id"]
      user_id = args["user_id"]

      likeable = likeable_type.constantize.find_by(id: likeable_id)
      user = User.find_by(id: user_id)
      return unless likeable && user

      LikeNotifier.new(user, likeable).notify
    end
  end
end
