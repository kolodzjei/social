# frozen_string_literal: true

module Notifications
  class MessageNotifierJob
    include Sidekiq::Job

    def perform(args)
      conversation = Conversation.find_by(id: args["conversation_id"])
      actor = User.find_by(id: args["actor_id"])
      return unless actor && conversation

      Notifications::MessageNotifier.new(conversation, actor).notify
    end
  end
end
