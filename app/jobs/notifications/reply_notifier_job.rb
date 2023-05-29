# frozen_string_literal: true

module Notifications
  class ReplyNotifierJob
    include Sidekiq::Job

    def perform(args)
      reply = Reply.find_by(id: args["reply_id"])
      actor = User.find_by(id: args["actor_id"])
      return unless reply && actor

      ReplyNotifier.new(actor, reply).notify
    end
  end
end
