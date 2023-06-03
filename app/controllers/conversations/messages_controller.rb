# frozen_string_literal: true

module Conversations
  class MessagesController < ApplicationController
    before_action :authenticate_user!

    def create
      @conversation = current_user.conversations.find_by(id: params[:conversation_id])
      return redirect_to(conversations_path, alert: "Conversation not found.") unless @conversation

      @message = @conversation.messages.build(message_params.merge(user: current_user))
      unless @message.save
        redirect_to(conversation_path(@conversation), alert: @message.errors.full_messages.to_sentence)
      end

      send_notification
    end

    private

    def message_params
      params.require(:message).permit(:content)
    end

    def send_notification
      Notifications::MessageNotifierJob.perform_async({
          conversation_id: @conversation.id,
          actor_id: current_user.id,
        }.stringify_keys)
    end
  end
end
