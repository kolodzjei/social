# frozen_string_literal: true

module Notifications
  class MessageNotifier
    def initialize(conversation, actor)
      @conversation = conversation
      @actor = actor
    end

    def notify
      notification = Notification.find_or_initialize_by(
        content: content,
        user: user,
        target: conversation,
        actor: actor,
      )

      if notification.new_record?
        notification.save
      else
        notification.touch
      end
    end

    private

    attr_reader :conversation, :actor

    def content
      "sent you a message."
    end

    def user
      conversation.sender == actor ? conversation.recipient : conversation.sender
    end
  end
end
